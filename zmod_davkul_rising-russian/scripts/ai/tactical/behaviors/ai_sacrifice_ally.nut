this.ai_sacrifice_ally <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		PossibleSkills = [
			"actives.sacrifice_ally"
		],
		Skill = null,
		IsTravelling = false
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.ModDavkulPriestSacrifice;
		this.m.Order = this.Const.AI.Behavior.Order.ModDavkulPriestSacrifice;
		this.m.IsThreaded = true;
		this.behavior.create();
	}
	
	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.Skill = null;
		this.m.TargetTile = null;
		this.m.IsTravelling = false;
		local time = this.Time.getExactTime();
		local myTile = _entity.getTile();

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = _entity.getSkills().getSkillByID("actives.sacrifice_ally");

		if (this.m.Skill == null || !this.m.Skill.isUsable() || !this.m.Skill.isAffordable())
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		

		yield null;
		local sacrifices = []

		foreach (sac in this.getAgent().getKnownAllies())
		{
			if (sac.m.Type == this.Const.EntityType.Cultist_Sacrifice) sacrifices.push(sac)
		}

		if (sacrifices.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local alliedFactions = _entity.getAlliedFactions();
		local potentialSacrifices = []
		foreach( sac in sacrifices )
		{
			local sacTile = sac.getTile()
			if (!this.m.Skill.isInRange(sacTile))
			{
				continue;
			}

			local score = 1.0;
			local dist = sacTile.getDistanceTo(myTile);
			score -= dist * 5
			this.printDebug(format("расстояние и оценка: %i %f ", dist, score), "mod_cultists");
			
			if (dist > 2)
			{
				continue;
			}

			if (!this.m.Skill.onVerifyTarget(myTile, sacTile))
			{
				continue;
			}

			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			potentialSacrifices.push({
				Tile = sacTile,
				Score = score
			});
		}
		if (potentialSacrifices.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		potentialSacrifices.sort(this.onSortByScore);
		local navigator = this.Tactical.getNavigator();
		local bestTarget;
		local bestIntermediateTile;
		local bestCost = -9999;
		local bestTiles = 0;
		local n = 0;
		local maxRange = this.m.Skill.getMaxRange();
		local entityActionPointCosts = _entity.getActionPointCosts();
		local entityFatigueCosts = _entity.getFatigueCosts();

		foreach( sac in potentialSacrifices )
		{
			n = ++n;	

			if (n > this.Const.AI.Behavior.RaiseUndeadMaxAttempts && bestTarget != null)
			{
				break;
			}

			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local score = 0 + sac.Score;
			local tiles = 0;
			local intermediateTile;

			if (!this.m.Skill.isInRange(sac.Tile))
			{
				this.printDebug(format("за пределами досягаемости"), "mod_cultists");
				
				score = 0
				local settings = navigator.createSettings();
				settings.ActionPointCosts = entityActionPointCosts;
				settings.FatigueCosts = entityFatigueCosts;
				settings.FatigueCostFactor = 0.0;
				settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
				settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
				settings.AllowZoneOfControlPassing = false;
				settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
				settings.AlliedFactions = _entity.getAlliedFactions();
				settings.Faction = _entity.getFaction();

				if (!_entity.getCurrentProperties().IsRooted && navigator.findPath(myTile, sac.Tile, settings, maxRange))
				{
					local movementCosts = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());

					if (movementCosts.IsComplete && !this.m.Skill.onVerifyTarget(movementCosts.End, sac.Tile))
					{
						continue;
					}

					if (!movementCosts.IsComplete)
					{
						intermediateTile = movementCosts.End;
					}

					if (movementCosts.End.IsBadTerrain)
					{
						score = score - this.Const.AI.Behavior.RaiseUndeadMoveToBadTerrainPenalty * this.getProperties().EngageOnBadTerrainPenaltyMult;
					}

					if (this.getProperties().EngageOnBadTerrainPenaltyMult != 0.0)
					{
						score = score - movementCosts.End.TVLevelDisadvantage;
					}

					score = score - movementCosts.ActionPointsRequired;
					score = score + movementCosts.End.Level;
					local inAllyZOC = movementCosts.End.getZoneOfControlCount(_entity.getFaction());
					score = score + inAllyZOC * this.Const.AI.Behavior.RaiseUndeadAllyZocBonus;
					tiles = movementCosts.Tiles;
				}
				else
				{
					continue;
				}
			}
			else
			{

				if (!this.m.Skill.onVerifyTarget(myTile, sac.Tile))
				{
					this.printDebug(format("Жертва: не удалось проверить цель"), "mod_cultists");
					
					continue;
				}
				local inAllyZOC = _entity.getTile().getZoneOfControlCount(_entity.getFaction());
				score = score + inAllyZOC * this.Const.AI.Behavior.RaiseUndeadAllyZocBonus;
				score = score + myTile.Level;
			}

			if (score > bestCost)
			{
				bestTarget = sac.Tile;
				bestCost = score;
				bestTiles = tiles;
				bestIntermediateTile = intermediateTile;
			}
		}

		if (bestTarget == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.TargetTile = bestTarget;
		this.m.IsTravelling = !this.m.Skill.isInRange(this.m.TargetTile);

		if (this.m.IsTravelling && bestIntermediateTile != null && bestIntermediateTile.ID == myTile.ID)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		return 10000
	}

	function onBeforeExecute( _entity )
	{
		if (this.m.IsTravelling)
		{
			this.getAgent().getOrders().IsEngaging = true;
			this.getAgent().getOrders().IsDefending = false;
			this.getAgent().getIntentions().IsDefendingPosition = false;
			this.getAgent().getIntentions().IsEngaging = true;
		}
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			if (this.m.IsTravelling)
			{
				local navigator = this.Tactical.getNavigator();
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
				navigator.findPath(_entity.getTile(), this.m.TargetTile, settings, this.m.Skill.getMaxRange());

				if (this.Const.AI.PathfindingDebugMode)
				{
					navigator.buildVisualisation(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
				}

				local movement = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
				this.getAgent().adjustCameraToDestination(movement.End);

				if (this.Const.AI.VerboseMode)
				{
					this.logInfo("* " + _entity.getName() + ": Перемещение в зону действия, чтобы использовать умение 'Принести в жертву'");
				}

				this.m.IsFirstExecuted = false;
				return false;
			}
			else
			{
				if (this.m.TargetTile.IsVisibleForPlayer && _entity.isHiddenToPlayer())
				{
					_entity.setDiscovered(true);
					_entity.getTile().addVisibilityForFaction(this.Const.Faction.Player);
				}

				this.getAgent().adjustCameraToTarget(this.m.TargetTile);
				this.m.IsFirstExecuted = false;
				return false;
			}
		}

		if (this.m.IsTravelling)
		{
			if (!this.Tactical.getNavigator().travel(_entity, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue()))
			{
				this.m.IsTravelling = false;
				this.m.TargetTile = null;
				return true;
			}
		}
		else
		{
			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": использует умение 'Принести в жертву'!");
			}

			if (this.m.Skill.use(this.m.TargetTile))
			{
				if (!_entity.isHiddenToPlayer() || this.m.TargetTile.IsVisibleForPlayer)
				{
					this.getAgent().declareAction();
					this.getAgent().declareEvaluationDelay(this.m.Skill.getDelay());
				}
			}

			this.m.Skill = null;
			this.m.TargetTile = null;
			return true;
		}
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
});

