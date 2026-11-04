this.ai_set_bear_trap <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		PossibleSkills = [
			"actives.sb_beartrap_skill"
		],
		Skill = null,
		SelectedSkillID = null,
		GoToTile = null
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.SetBearTrap;
		this.m.Order = this.Const.AI.Behavior.Order.SetBearTrap;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.TargetTile = null;
		this.m.Skill = null;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (!this.getAgent().hasVisibleOpponent())
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local targets = this.queryTargetsInMeleeRange(1, 3);

		if (targets.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local bestTarget = {
			Target = null,
			Score = 0.0
		};
		local func = this.findBestTarget(_entity, targets, bestTarget);

		while (resume func == null)
		{
			yield null;
		}

		if (bestTarget.Target == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{

            local hasQuickHands = _entity.getSkills().hasSkill("perk.quick_hands");

            if (!hasQuickHands && _entity.getActionPoints() < this.Const.Tactical.Settings.SwitchItemAPCost)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            local items = _entity.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);

            if (items.len() == 0)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            foreach( it in items )
            {
                if (it.getID() == "tool.bear_trap_item")
                {
		            this.m.SelectedSkillID = "tool.bear_trap_item";
		            score = score * 1.5;
                    break;
                }
            }

            if (this.m.SelectedSkillID == null)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }
		}
		else
		{
		    score = score * this.getFatigueScoreMult(this.m.Skill);
		}
		this.m.TargetTile = bestTarget.Target;
		return this.Const.AI.Behavior.Score.Attack * bestTarget.Score * score;
	}

	function onExecute( _entity )
	{
		if (this.m.TargetTile != null)
		{
            if (this.m.Skill == null)
            {
                local items = _entity.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);
                foreach( it in items )
                {
                    if (it.getID() == "tool.bear_trap_item")
                    {
                        local mainHand = _entity.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

                        if (!mainHand.isItemType(this.Const.Items.ItemType.TwoHanded))
                        {
                            local offHand = _entity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
                            _entity.getItems().unequip(offHand);
                            _entity.getItems().addToBag(offHand);
                        }
                        _entity.getItems().removeFromBag(it);
                        _entity.getItems().unequip(mainHand);
                        _entity.getItems().addToBag(mainHand);
                        _entity.getItems().equip(it);

    		            this.m.Skill = this.selectSkill(this.m.PossibleSkills);
                        break;
                    }
                }
            }

			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Using " + this.m.Skill.getName() + " against " + this.m.TargetTile.getEntity().getName() + "!");
			}

			if (this.m.TargetTile == _entity.getTile())
			{
                local navigator = this.Tactical.getNavigator();
                local settings = navigator.createSettings();
                local acceptableDistanceFromDest = 0;
                settings.ActionPointCosts = _entity.getActionPointCosts();
                settings.FatigueCosts = _entity.getFatigueCosts();
                settings.FatigueCostFactor = 0.0;
                settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
                settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
                settings.AllowZoneOfControlPassing = false;
                settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
                settings.AlliedFactions = _entity.getAlliedFactions();
                settings.Faction = _entity.getFaction();
                navigator.findPath(_entity.getTile(), this.m.GoToTile, settings, acceptableDistanceFromDest);

                if (this.Const.AI.PathfindingDebugMode)
                {
                    navigator.buildVisualisation(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
                }

                local movement = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());

                if (movement.Tiles == 0)
                {
                    return true;
                }

                this.m.Agent.adjustCameraToDestination(movement.End);
			    this.m.GoToTile = null;

			}

			this.m.Skill.use(this.m.TargetTile);
			this.getAgent().declareEvaluationDelay(800);

			if (_entity.isAlive() && (!_entity.isHiddenToPlayer() || this.m.TargetTile.IsVisibleForPlayer))
			{
				this.getAgent().declareAction();
			}

			this.m.TargetTile = null;
			this.m.Skill = null;
			this.m.SelectedSkillID = null;
		}

		return true;
	}

	function findBestTarget( _entity, _targets, _bestTarget )
	{
		local bestTarget;
		local bestScore = -9000.0;
		local knownAllies = this.getAgent().getKnownAllies();
		local time = this.Time.getExactTime();

		foreach( target in _targets )
		{
			local score = 1.0;

			if (target.getCurrentProperties().IsRooted)
			{
				continue;
			}
			
			local tile = findTileToPlaceTrap(_entity, target);

			if (tile == null)
			{
				continue;
			}

			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			score = score - tile.TVTotal * this.Const.AI.Behavior.ThrowNetTVMult;

			if (tile.IsBadTerrain)
			{
				score = score + this.Const.AI.Behavior.ThrowNetBadTerrainBonus;
			}

			if (this.hasNegativeTileEffect(tile, target))
			{
				score = score + this.Const.AI.Behavior.ThrowNetBadTerrainBonus;
			}

			score = score + target.getCurrentProperties().getMeleeDefense() / 2;

			if (!target.hasRangedWeapon())
			{
				score = score + this.Const.AI.Behavior.ThrowNetNoRangedWeaponBonus;
			}

			score = score * target.getCurrentProperties().TargetAttractionMult;

			if (target.isTurnDone() && target.getSkills().hasSkill("effects.adrenaline"))
			{
				score = score * this.Const.AI.Behavior.ThrowNetVSAdrenalineMult;
			}

			if (target.getType() == this.Const.EntityType.Wardog || target.getType() == this.Const.EntityType.Warhound)
			{
				score = score * this.Const.AI.Behavior.ThrowNetVSWardogsMult;
			}

			if (score > bestScore)
			{
				bestScore = score;
				bestTarget = tile;
			}
		}

		_bestTarget.Target = bestTarget;
		_bestTarget.Score = bestScore * 0.1;
		return true;
	}
	
	function findTileToPlaceTrap( _entity, _target )
	{
        local targetTile = _target.getTile();
        local entityTile = _entity.getTile();
        local dirTo = entityTile.getDirectionTo(targetTile);

        if (entityTile.hasNextTile(dirTo))
        {
            local tile = entityTile.getNextTile(dirTo);

            if (tile.IsEmpty && tile.Properties.Effect == null)
            {
                return tile;
            }
        }

        local altdir = dirTo - 1 >= 0 ? dirTo - 1 : 5;

        if (entityTile.hasNextTile(altdir))
        {
            local tile = entityTile.getNextTile(altdir);

            if (tile.IsEmpty && tile.Properties.Effect == null)
            {
                return tile;
            }
        }

        altdir = dirTo + 1 <= 5 ? dirTo + 1 : 0;

        if (entityTile.hasNextTile(altdir))
        {
            local tile = entityTile.getNextTile(altdir);

            if (tile.IsEmpty && tile.Properties.Effect == null)
            {
                return tile;
            }
        }

        return null;
	}

});

