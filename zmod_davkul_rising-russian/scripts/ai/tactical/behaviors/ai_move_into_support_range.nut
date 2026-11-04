this.ai_move_into_support_range <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		ValidTargets = [],
		PotentialDanger = [],
		CurrentDanger = 0.0,
		SkillCost = {
			ActionPointCost = 5,
			FatigueCost = 25
		},
		TargetScore = 0,
		OutOfAPAfterMove = false,
		IsUsedThisTurn = false,
		IsWaitingBeforeMove = false

	},

	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.ModDavkulPriestSupport;
		this.m.Order = this.Const.AI.Behavior.Order.ModDavkulPriestSupport;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onTurnStarted()
	{
		this.m.OutOfAPAfterMove = false;
		this.m.IsUsedThisTurn = false;
	}

	function onEvaluate( _entity )
	{
		this.m.TargetTile = null;
		this.m.TargetScore = 0;
		this.m.IsWaitingBeforeMove = false;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getCurrentProperties().IsRooted)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.getAgent().getBehavior(this.Const.AI.Behavior.ID.Defend).m.IsDoneThisTurn)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		
		local zoc = _entity.getTile().getZoneOfControlCountOtherThan(_entity.getAlliedFactions());

		if (zoc > 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local func = this.getTilesInRange(_entity)
		while (resume func == null)
		{
			yield null;
		}

		if (this.m.TargetTile == null || _entity.getTile().isSameTileAs(this.m.TargetTile))
		{
			this.printDebug("возврат нуля для перемещения на нужное расстояние", "mod_cultists")
			return this.Const.AI.Behavior.Score.Zero;
		}
		if (!this.getStrategy().getStats().IsEngaged && _entity.isAbleToWait() && this.Tactical.TurnSequenceBar.isAllyStillToAct(_entity))
		{
			local allies = this.getAgent().getKnownAllies();
			local someoneStillToMove = false;

			foreach( ally in allies )
			{
				if (!ally.isTurnDone() && ally.isArmedWithMeleeWeapon() && ally.getIdealRange() == 1 && ally.getActionPoints() >= 4)
				{
					someoneStillToMove = true;
					break;
				}
			}

			if (someoneStillToMove)
			{
				this.m.IsWaitingBeforeMove = true;
			}
		}
		this.printDebug("возврат "+ this.m.TargetScore + " на расстояние поддержки", "mod_cultists")
		return this.m.TargetScore;
	}

	function onBeforeExecute( _entity )
	{
		this.getAgent().getOrders().IsEngaging = !this.m.OutOfAPAfterMove;
		this.getAgent().getOrders().IsDefending = this.m.OutOfAPAfterMove;
		this.getAgent().getIntentions().IsDefendingPosition = this.m.OutOfAPAfterMove;
		this.getAgent().getIntentions().IsEngaging = !this.m.OutOfAPAfterMove;
	}

	function onExecute( _entity )
	{
		if (this.m.IsWaitingBeforeMove && this.Tactical.TurnSequenceBar.entityWaitTurn(_entity))
		{
			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": ждет, пока другие не двинутся с места!");
			}

			return true;
		}

		local navigator = this.Tactical.getNavigator();
		if (this.m.IsFirstExecuted)
		{
			local settings = navigator.createSettings();
			settings.ActionPointCosts = _entity.getActionPointCosts();
			settings.FatigueCosts = _entity.getFatigueCosts();
			settings.FatigueCostFactor = 0.0;
			settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
			settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
			settings.AllowZoneOfControlPassing = false;
			settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
			settings.AlliedFactions = _entity.getAlliedFactions();
			settings.Faction = _entity.getFaction();
			navigator.findPath(_entity.getTile(), this.m.TargetTile, settings, 0);


			local movement = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());

			if (movement.Tiles == 0)
			{
				this.printDebug("Не найдено клеток для перемещения", "mod_cultists")
				return true;
			}

			this.m.Agent.adjustCameraToDestination(movement.End);

			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Перемещение в зону действия боевого горна: " + movement.Tiles + " плитки");
			}
		
			this.m.IsFirstExecuted = false;
			return;
		}

		#this.printDebug("На втором этапе выполнения", "mod_cultists")
		if (!navigator.travel(_entity, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue()))
		{
			this.m.TargetTile = null;
			this.m.TargetScore = 0;
			return true;
		}
		return false;
	
	}

	function onSortByScore( _a, _b )
	{
		if (_a.Score > _b.Score)
		{
			return -1;
		}
		else if (_a.Score < _b.Score)
		{
			return 1;
		}

		return 0;
	}

	function getTilesInRange(_entity)
	{
		local time = this.Time.getExactTime();
		local myTile = _entity.getTile()
		local tiles = []

		local possibleTiles = this.queryDestinationsInRange(myTile, 1, 4, 3);
		possibleTiles.push(myTile);
		local availableAP = _entity.getActionPoints() - this.m.SkillCost.ActionPointCost
		local navigator = this.Tactical.getNavigator();
		local settings = navigator.createSettings();
		settings.ActionPointCosts = _entity.getActionPointCosts()
		settings.FatigueCosts = _entity.getFatigueCosts();
		settings.FatigueCostFactor = 0.0;
		settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
		settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
		settings.AllowZoneOfControlPassing = false;
		settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
		settings.AlliedFactions = _entity.getAlliedFactions();
		settings.Faction = _entity.getFaction();

		foreach (tile in possibleTiles)
		{
			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local result = {
				Tile = tile,
				Score = 0.0,
				OutOfAPAfterMove = _entity.getActionPoints() < this.m.SkillCost.ActionPointCost
			}
			tiles.append(result)
			if (tile.isSameTileAs(myTile))
			{
				this.getTileValue(tile, _entity, result)
			}
			else if (navigator.findPath(myTile, tile, settings, 0))
			{
				
				local movementCosts = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue() - this.m.SkillCost.FatigueCost);
				if (movementCosts.Tiles != 0 && movementCosts.IsComplete)
				{
					if(movementCosts.ActionPointsRequired > availableAP)
					{
						result.OutOfAPAfterMove = true;
						this.printDebug("не могу использовать боевой горн ", "mod_cultists")
					}
					this.getTileValue(tile, _entity, result)
				}
			}
			
		}
		if (tiles.len() == 0) return false;

		tiles.sort(this.onSortByScore)
		this.m.TargetTile = tiles[0].Tile
		this.printDebug("Идентификатор выбранной плитки: " + tiles[0].Tile.ID, "mod_cultists")
		this.m.TargetScore = tiles[0].Score
		this.m.OutOfAPAfterMove = tiles[0].OutOfAPAfterMove
		return true
	}

	function queryDestinationsInRange( _targetTile, _minRange, _maxRange, _maxLevelDifference = 1 )
	{

		local result = {
			TargetTile = _targetTile,
			Destinations = []
		};
		this.Tactical.queryTilesInRange(_targetTile, _minRange, _maxRange, true, [], this.onQueryDestinationInRange, result);
		return result.Destinations;
	}

	function getTileValue(_tile, _entity, _result)
	{
		local actors = this.Tactical.Entities.getAllInstances();
		local myTile = _entity.getTile();
		local useScore = 0.0;
		local friendlyScoreInRange = 0
		local friendlyScoreBoostMorale = 0
		local enemyScoreInRange = 0
		local enemyScoreDefeatMorale = 0
		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (!a.isAlive() || a.getID() == _entity.getID() || a.getCurrentProperties().TargetAttractionMult < 0.5)
				{
					continue;
				}


				local distance = a.getTile().getDistanceTo(_tile);

				if (a.getFaction() == _entity.getFaction())
				{
					if (distance <= 5 && a.getMoraleState() != this.Const.MoraleState.Ignore) friendlyScoreInRange += 6 //just stay in range of allies except sacrifices the poor fucks
					if (_result.OutOfAPAfterMove) continue
					if (a.getMoraleState() != this.Const.MoraleState.Ignore && a.getMoraleState() != this.Const.MoraleState.Confident && distance <= 5)
					{
						friendlyScoreBoostMorale += this.Math.max(0, (5 - distance));
					}
					
				}
				else if (!a.isAlliedWith(_entity))
				{
					if (distance == 1 || (distance == 2 && this.has2hRange(distance, a))) enemyScoreInRange -= 20
					if (_result.OutOfAPAfterMove) continue
					if (a.getMoraleState() != this.Const.MoraleState.Ignore && a.getMoraleState() != this.Const.MoraleState.Fleeing && 
						a.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] <= 1.0 && a.getBravery() < 80 && distance <= 7)
					{
						enemyScoreDefeatMorale += this.Math.max(0, (7 - distance));
					}
				}

			}
		}
		useScore = friendlyScoreInRange + friendlyScoreBoostMorale + enemyScoreInRange + enemyScoreDefeatMorale
		// this.printDebug(
		// 	"Идентификатор плитки: " + _tile.ID + "\n"+
		// 	"friendlyScoreInRange: " + friendlyScoreInRange + "\n"+
		// 	"friendlyScoreBoostMorale: " + friendlyScoreBoostMorale + "\n"+
		// 	"enemyScoreInRange: " + enemyScoreInRange + "\n"+
		// 	"enemyScoreDefeatMorale: " + enemyScoreDefeatMorale + "\n"+
		// 	"Всего: " + useScore, "mod_cultists"
		// 	)
		
		_result.Score += useScore;
	}

	//crude way to check 2 tile danger
	function has2hRange(_distance, _entity)
	{
		this.printDebug(format("Checking for %s", _entity.getName()), "mod_cultists");
		local mainhand = _entity.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand)
		if (mainhand != null && mainhand.isItemType(this.Const.Items.ItemType.Weapon) && "getRangeIdeal" in mainhand && mainhand.getRangeIdeal() == _distance) return true
		foreach (item in _entity.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag))
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Weapon) && "getRangeIdeal" in item && item.getRangeIdeal() == _distance) return true
		}
		return false
	}


});
