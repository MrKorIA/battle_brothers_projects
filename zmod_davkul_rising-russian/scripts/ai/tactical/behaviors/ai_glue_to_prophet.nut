this.ai_glue_to_prophet <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		IsWaitingAfterMove = false,
		IsWaitingBeforeMove = false,
		IsHoldingPosition = true,
		IsDoneThisTurn = false
	},
	function isDoneThisTurn()
	{
		return this.m.IsDoneThisTurn;
	}

	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.ModDavkulSacrificeStick;
		this.m.Order = this.Const.AI.Behavior.Order.ModDavkulSacrificeStick;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.TargetTile = null;
		this.m.IsWaitingAfterMove = false;
		this.m.IsHoldingPosition = false;
		this.m.IsWaitingBeforeMove = false;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP || score == 0.0)
		{
			this.printDebug(format("ОД/оценка 0"), "mod_cultists");
			
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.m.IsDoneThisTurn)
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


		local myTile = _entity.getTile();

		if (myTile.hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local allies = this.getAgent().getKnownAllies();
		local vips = 0;
		local vipStillToMove = 0;
		local vipStillToMoveAndAdjacent = 0;

		foreach( a in allies )
		{
			if (a.getCurrentProperties().TargetAttractionMult > 1.0 && a.getAIAgent().getBehavior(this.Const.AI.Behavior.ID.Protect) == null)
			{
				if (!a.isTurnDone() && a.getActionPoints() >= 4 && !a.getCurrentProperties().IsStunned && !a.getCurrentProperties().IsRooted)
				{
					vipStillToMove = ++vipStillToMove;

					if (a.getTile().getDistanceTo(myTile) == 1)
					{
						vipStillToMoveAndAdjacent = ++vipStillToMoveAndAdjacent;
					}
				}

				vips = ++vips;
				break;
			}
		}

		if (vips == 0)
		{
			this.printDebug(format("нет VIP?"), "mod_cultists");
			
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (vipStillToMove >= 1 && this.Tactical.TurnSequenceBar.canEntityWait(_entity))
		{
			this.m.IsWaitingBeforeMove = true;
		}
		else
		{
			local func = this.selectBestTargetTile(_entity);

			while (resume func == null)
			{
				yield null;
			}

			if (this.m.TargetTile == null)
			{
				this.printDebug(format("нет targettile"), "mod_cultists");
				return this.Const.AI.Behavior.Score.Zero;
			}
		}

		if (!this.m.IsWaitingBeforeMove && myTile.isSameTileAs(this.m.TargetTile))
		{
			if (this.m.IsHoldingPosition)
			{
				this.printDebug(format("удержание IsHoldingPosition"), "mod_cultists");
				
				return this.Const.AI.Behavior.Score.Zero;
			}
			else
			{
				this.m.IsHoldingPosition = true;
			}
		}
		this.printDebug("Финальный счёт жертв: " + (this.Const.AI.Behavior.Score.Protect * score), "mod_cultists");
		
		return this.Const.AI.Behavior.Score.Protect * score;
	}

	function onTurnStarted()
	{
		this.m.IsDoneThisTurn = false;
	}

	function onTurnResumed()
	{
		this.m.IsDoneThisTurn = false;
	}

	function onBeforeExecute( _entity )
	{
		this.getAgent().getOrders().IsEngaging = false;
		this.getAgent().getOrders().IsDefending = true;
		this.getAgent().getIntentions().IsDefendingPosition = true;
		this.getAgent().getIntentions().IsEngaging = false;

		if (this.m.IsWaitingAfterMove || this.m.IsHoldingPosition)
		{
			this.m.IsDoneThisTurn = true;
		}
	}

	function onExecute( _entity )
	{
		if (this.m.IsWaitingBeforeMove)
		{
			if (this.Tactical.TurnSequenceBar.entityWaitTurn(_entity))
			{
				if (this.Const.AI.VerboseMode)
				{
					this.logInfo("* " + _entity.getName() + ": Жду, пока другие не двинутся с места!");
				}

				this.m.TargetTile = null;
				return true;
			}
		}

		if (this.m.IsHoldingPosition)
		{
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

			if (this.Const.AI.PathfindingDebugMode)
			{
				navigator.buildVisualisation(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
			}

			local movement = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
			this.m.Agent.adjustCameraToDestination(movement.End);

			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Занимаю защитную позицию.");
			}

			this.m.IsFirstExecuted = false;
			return;
		}

		if (!navigator.travel(_entity, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue()))
		{
			this.m.TargetTile = null;
			return true;
		}

		return false;
	}

	function selectBestTargetTile( _entity )
	{
		// Function is a generator.
		local time = this.Time.getExactTime();
		local myTile = _entity.getTile();
		local allAllies = this.getAgent().getKnownAllies();
		local allOpponents = this.getAgent().getKnownOpponents();
		local potential_tiles = [];

		foreach( a in allAllies )
		{
			if (a.getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				continue;
			}

			if (a.getCurrentProperties().TargetAttractionMult <= 1.0 || a.getCurrentProperties().TargetAttractionMult <= _entity.getCurrentProperties().TargetAttractionMult)
			{
				continue;
			}

			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local importantAlly = a;
			local importantAllyTile = a.getTile();
			local dirs = [
				0,
				0,
				0,
				0,
				0,
				0
			];

			for( local i = 0; i != 6; i = ++i )
			{

				if (!importantAllyTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = importantAllyTile.getNextTile(i);
					for( local j = 0; j != 6; j = ++j )
					{
						if (!tile.hasNextTile(j))
						{
						}
						else
						{
							local adjacentTile = tile.getNextTile(j);
							if (!adjacentTile.IsEmpty && adjacentTile.ID != myTile.ID) continue

							local score2 = 5 - importantAllyTile.getDistanceTo(adjacentTile);
							
							potential_tiles.push({
								Tile = adjacentTile,
								Score = score2,
								TileBonus = 0
								AllyDefendBonus = 0
							});

						}
					}

					if (!tile.IsEmpty && tile.ID != myTile.ID) continue

					local score = 5;
					local immediateBonus = 0;
					score = score - importantAllyTile.getDistanceTo(tile);
					local importantAlliesAtTile = 0;

					local dirs = [
						0,
						0,
						0,
						0,
						0,
						0
					];

					foreach( opponent in allOpponents )
					{
						local actor = opponent.Actor
						local dir = tile.getDirection8To(actor.getTile());
						local mult = this.isRangedUnit(actor) ? 2 : 1;
						mult = mult * (7.0 / tile.getDistanceTo(actor.getTile()));

						switch(dir)
						{
						case this.Const.Direction8.W:
							dirs[this.Const.Direction.NW] += 4 * mult;
							dirs[this.Const.Direction.SW] += 4 * mult;
							break;

						case this.Const.Direction8.E:
							dirs[this.Const.Direction.NE] += 4 * mult;
							dirs[this.Const.Direction.SE] += 4 * mult;
							break;

						default:
							local dir = tile.getDirectionTo(actor.getTile());
							local dir_left = dir - 1 >= 0 ? dir - 1 : 6 - 1;
							local dir_right = dir + 1 < 6 ? dir + 1 : 0;
							dirs[dir] += 4 * mult;
							dirs[dir_left] += 3 * mult;
							dirs[dir_right] += 3 * mult;
							break;
						}
					}
					local already_in = false;

					foreach( t in potential_tiles )
					{
						if (t.Tile.ID == tile.ID)
						{
							t.AllyDefendBonus += a.getCurrentProperties().TargetAttractionMult * this.Const.AI.Behavior.ProtectAllyAttractionBonus;
							t.TileBonus += dirs[i] + immediateBonus;
							t.Score += score;
							already_in = true;
							break;
						}
					}

					if (!already_in)
					{
						potential_tiles.push({
							Tile = tile,
							Score = score,
							TileBonus = dirs[i] + immediateBonus,
							AllyDefendBonus = a.getCurrentProperties().TargetAttractionMult * this.Const.AI.Behavior.ProtectAllyAttractionBonus
						});
					}
					
				}
			}
		}


		if (potential_tiles.len() == 0)
		{
			this.printDebug(format("потенциальная длина клетки 0"), "mod_cultists");
			
			return false
		}

		local navigator = this.Tactical.getNavigator();
		local settings = navigator.createSettings();
		local myTile = _entity.getTile();
		local myFaction = _entity.getFaction();
		potential_tiles.sort(this.onSortByScore);
		local attempts = 0;
		local time = this.Time.getExactTime();
		local bestDestination;
		local bestScore = -9000;
		local bestIsForNextTurn = false;
		local bestWaitAfterMove = false;
		settings.ActionPointCosts = _entity.getActionPointCosts();
		settings.FatigueCosts = _entity.getFatigueCosts();
		settings.FatigueCostFactor = 0.0;
		settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
		settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
		settings.AllowZoneOfControlPassing = false;
		settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
		settings.AlliedFactions = _entity.getAlliedFactions();
		settings.Faction = _entity.getFaction();

		foreach( t in potential_tiles )
		{
			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local apCost = 0;
			local waitAfterMove = false;
			local isForNextTurn = false;
			attempts = ++attempts;

			if (attempts > this.Const.AI.Behavior.DefendMaxAttempts)
			{
				break;
			}

			if (!t.Tile.isSameTileAs(myTile))
			{
				if (navigator.findPath(myTile, t.Tile, settings, 0))
				{
					local movementCosts = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
					apCost = apCost + movementCosts.ActionPointsRequired;
					isForNextTurn = false;
					waitAfterMove = false;

					if (!movementCosts.IsComplete)
					{
						if (movementCosts.Tiles == 0)
						{
							isForNextTurn = true;
						}
						else
						{
							waitAfterMove = true;
						}
					}
				}
				else
				{
					this.printDebug(format("не удалось найти путь"), "mod_cultists");
					
					continue;
				}
			}

			local allyDefendBonus = t.AllyDefendBonus;
			local TileBonus = t.TileBonus * this.Const.AI.Behavior.ProtectAllyDirectionMult;
			local score = TileBonus + allyDefendBonus - apCost * this.Const.AI.Behavior.ProtectAllyAPCostMult;

			if (score > bestScore)
			{
				bestDestination = t.Tile;
				bestIsForNextTurn = isForNextTurn;
				bestWaitAfterMove = waitAfterMove;
				bestScore = score;
			}
		}

		if (bestDestination != null && bestIsForNextTurn == false)
		{
			if (this.Const.AI.VerboseMode && bestDestination.isSameTileAs(_entity.getTile()))
			{
				this.logInfo("* " + _entity.getName() + ": На самом деле, я бы предпочел остаться там, где стою");
			}

			this.m.TargetTile = bestDestination;
			this.m.IsWaitingAfterMove = bestWaitAfterMove;
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

	function onSortByLowestScore( _d1, _d2 )
	{
		if (_d1.Score > _d2.Score)
		{
			return 1;
		}
		else if (_d1.Score < _d2.Score)
		{
			return -1;
		}

		return 0;
	}

});

