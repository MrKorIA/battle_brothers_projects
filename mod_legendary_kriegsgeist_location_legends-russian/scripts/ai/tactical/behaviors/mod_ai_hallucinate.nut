this.mod_ai_hallucinate <- ::inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		Danger = null,
		ScoreBonus = 1.0,
		PossibleSkills = [
			"actives.mod_hallucinate"
		],
		Skill = null
	},
	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.Charm;
		this.m.Order = ::Const.AI.Behavior.Order.Charm;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.Skill = null;
		this.m.TargetTile = null;
		this.m.Danger = null;
		this.m.ScoreBonus = 0.0;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (!this.getAgent().hasKnownOpponent())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		score = score * this.getFatigueScoreMult(this.m.Skill);
		local opponents = this.getAgent().getKnownOpponents();

		if (opponents.len() == 1)
		{
			if (!this.m.Skill.isViableTarget(_entity, opponents[0].Actor))
			{
				return ::Const.AI.Behavior.Score.Zero;
			}

			this.m.TargetTile = opponents[0].Actor.getTile();
			return 100000.0;
		}

		local func = this.calculateDanger(_entity, opponents);

		while (resume func == null)
		{
			yield null;
		}

		local func = this.findBestTarget(_entity, opponents);

		while (resume func == null)
		{
			yield null;
		}

		if (this.m.TargetTile == null)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.m.Danger = null;
		return 240.0 * (_entity.isEngagedInMelee() ? 0.5 : 1.0) * (this.m.Skill.isSpent() ? 0.25 : 1.0) * score + this.m.ScoreBonus;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.getAgent().adjustCameraToTarget(this.m.TargetTile);
			this.m.IsFirstExecuted = false;

			if (this.m.TargetTile.IsVisibleForPlayer && _entity.isHiddenToPlayer())
			{
				_entity.setDiscovered(true);
				_entity.getTile().addVisibilityForFaction(::Const.Faction.Player);
			}

			return false;
		}

		this.m.Skill.use(this.m.TargetTile);

		if (!_entity.isHiddenToPlayer() || this.m.TargetTile.IsVisibleForPlayer)
		{
			this.getAgent().declareAction();
			this.getAgent().declareEvaluationDelay(this.m.Skill.getDelay() + 500);
		}

		this.m.Skill = null;
		this.m.TargetTile = null;
		return true;
	}

	function findBestTarget( _entity, _targets )
	{
		// Function is a generator.
		local myTile = _entity.getTile();
		local knownAllies = this.getAgent().getKnownAllies();
		local bestScore = 0.0;
		local bestTarget;
		local time = ::Time.getExactTime();

		foreach( opponent in _targets )
		{
			if (!this.m.Skill.isViableTarget(_entity, opponent.Actor))
			{
				continue;
			}

			if (opponent.Actor.getSkills().hasSkill("effects.mod_hallucinated"))
			{
				continue;
			}

			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = ::Time.getExactTime();
			}

			local target = opponent.Actor;
			local opponentTile = opponent.Actor.getTile();
			local score = 100.0;
			local distanceToTarget = myTile.getDistanceTo(opponentTile);

			if (target.getMoraleState() == ::Const.MoraleState.Fleeing || target.getCurrentProperties().IsStunned || !target.getCurrentProperties().IsAbleToUseWeaponSkills)
			{
				continue;
			}

			score += target.getLevel() * ::Const.AI.Behavior.CharmLevelMult;
			score += target.getCurrentProperties().getMeleeSkill() * ::Const.AI.Behavior.CharmSkillMult;
			score -= distanceToTarget * ::Const.AI.Behavior.CharmDistanceMult;

			if (target.getCurrentProperties().IsImmuneToRoot)
			{
				score += 100.0;
			}

			if (target.getCurrentProperties().IsImmuneToPoison)
			{
				score += 100.0;
			}

			local targets = 0;
			local targetsInRange = this.queryEnemiesInMeleeRange(1, target.getIdealRange(), target);

			foreach( t in targetsInRange )
			{
				if (t.getID() != _entity.getID() && t.getCurrentProperties().TargetAttractionMult > 1.0)
				{
					targets = ++targets;
				}
			}

			score -= targets * 8;

			if (target.getCurrentProperties().IsRooted)
			{
				score *= ::Const.AI.Behavior.CharmRootedMult;
			}

			if (opponentTile.getZoneOfOccupationCount(target.getFaction()) != 0)
			{
				score *= 1.25;
			}

			if (distanceToTarget <= target.getIdealRange())
			{
				score *= ::Const.AI.Behavior.CharmMeleeDangerMult;
			}

			if (this.m.Danger.Danger <= 2 && this.m.Danger.PotentialDanger.find(target.getID()) != 0)
			{
				score *= 2.0;
			}

			if (target.getType() == ::Const.EntityType.Wardog || target.getType() == ::Const.EntityType.Warhound)
			{
				score *= ::Const.AI.Behavior.CharmWardogMult;
			}

			local targetsScore = 1.0;
			local targets = 0;
			local targetsNotLockedDown = 0;
			local targetsInRange = this.queryAlliesInMeleeRange(1, target.getIdealRange(), target);

			foreach( t in targetsInRange )
			{
				local s = this.queryTargetValue(target, t);
				targetsScore = targetsScore + s;
				targets = ++targets;

				if (t.getTile().getZoneOfControlCountOtherThan(t.getAlliedFactions()) == 0)
				{
					targetsNotLockedDown = ++targetsNotLockedDown;
				}
			}

			score *= (1.0 + (targetsScore + targetsNotLockedDown * ::Const.AI.Behavior.CharmTargetLockdownMult) * ::Const.AI.Behavior.CharmTargetsMult);

			local currentZOC = opponentTile.getZoneOfControlCountOtherThan(target.getAlliedFactions());

			if (currentZOC >= 3 || currentZOC >= 2 && target.getHitpointsPct() <= 0.25)
			{
				score *= ::Const.AI.Behavior.CharmEasierToKillMult;
			}

			if (target.isAbleToWait() && !target.isTurnDone())
			{
				score *= ::Const.AI.Behavior.CharmStillToActMult;
			}
			else if (!target.isAbleToWait() && target.getActionPoints() < target.getActionPointsMax())
			{
				score *= ::Const.AI.Behavior.CharmAlreadyWaitedMult;
			}

			if (!target.isArmed())
			{
				foreach (active in target.getSkills().queryActives())
				{
					if (active.isAttack() && !active.isHidden())
					{
						local p = target.getSkills().buildPropertiesForUse(active, null);
						local damageMax = this.Math.floor(p.DamageRegularMax * p.DamageRegularMult * p.DamageTotalMult * (active.isRanged() ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMaxMult);
						if (damageMax <= 30)
						{
							score *= ::Const.AI.Behavior.CharmTargetUnarmedMult;
						}
						break;
					}
				}
			}

			if (target.getCurrentProperties().IsResistantToAnyStatuses)
			{
				score *= 0.5;
			}

			score *= target.getCurrentProperties().TargetAttractionMult;

			if (score > bestScore)
			{
				bestScore = score;
				bestTarget = target;
			}
		}

		if (bestTarget != null)
		{
			this.m.TargetTile = bestTarget.getTile();
			this.m.ScoreBonus = bestScore * 0.1;
		}

		return true;
	}

	function calculateDanger( _entity, _targets )
	{
		// Function is a generator.
		local myTile = _entity.getTile();
		local currentDanger = 0.0;
		local potentialDanger = [];
		local time = ::Time.getExactTime();

		foreach( target in _targets )
		{
			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = ::Time.getExactTime();
			}

			local targetTile = target.Actor.getTile();
			local realDist = myTile.getDistanceTo(targetTile);

			if (realDist > ::Const.AI.Behavior.RangedEngageMaxDangerDist) continue;
			
			if (target.Actor.getMoraleState() == ::Const.MoraleState.Fleeing) continue;

			if (target.Actor.isNonCombatant()) continue;

			if (target.Actor.getCurrentProperties().IsImmuneToRoot || target.Actor.getCurrentProperties().IsImmuneToPoison || targetTile.getZoneOfControlCountOtherThan(target.Actor.getAlliedFactions()) < ::Const.AI.Behavior.RangedEngageIgnoreDangerMinZones) 
			{
				potentialDanger.push(target.Actor.getID());
				local danger = this.getDangerFromActor(target.Actor, myTile, _entity);
				currentDanger = currentDanger + danger;
			}
		}

		this.m.Danger = {
			Danger = currentDanger,
			PotentialDanger = potentialDanger
		};
		return true;
	}

	function getDangerFromActor( _actor, _target, _entity )
	{
		local d = this.queryActorTurnsNearTarget(_actor, _target, _entity);

		if (d.Turns <= ::Const.AI.Behavior.RangedEngageKeepMinTurnsAway && d.InZonesOfControl < 2)
		{
			if (d.InZonesOfOccupation != 0 || _actor.getCurrentProperties().IsRooted)
			{
				return 1.0;
			}
			else
			{
				return (1.0 - d.Turns) * 6.0;
			}
		}
		else
		{
			return 0.0;
		}
	}

});

