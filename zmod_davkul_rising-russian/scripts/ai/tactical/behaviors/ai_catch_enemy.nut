this.ai_catch_enemy <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		PossibleSkills = [
			"actives.catch_enemy"
		],
		Skill = null
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.ModDavkulMancatcherCatch;
		this.m.Order = this.Const.AI.Behavior.Order.ModDavkulMancatcherCatch;
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

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			this.printDebug("не удалось найти навык?", "mod_cultists")
			return this.Const.AI.Behavior.Score.Zero;
		}

		score = score * this.getFatigueScoreMult(this.m.Skill);
		local myTile = _entity.getTile();
		local targets = this.queryTargetsInMeleeRange(this.m.Skill.getMinRange(), this.m.Skill.getMaxRange() + (this.m.Skill.isRanged() ? myTile.Level : 0), this.m.Skill.getMaxLevelDifference());

		if (targets.len() == 0)
		{
			this.printDebug("не удалось найти врага в пределах досягаемости?", "mod_cultists")
			return this.Const.AI.Behavior.Score.Zero;
		}

		local bestTarget;

		if (this.m.Skill.isRanged())
		{
			bestTarget = this.queryBestRangedTarget(_entity, this.m.Skill, targets);
		}
		else
		{
			bestTarget = this.queryBestMeleeTarget(_entity, this.m.Skill, targets);
		}

		if (bestTarget.Target == null)
		{
			this.printDebug("не удалось найти лучшую цель?", "mod_cultists")
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.getAgent().getIntentions().IsChangingWeapons)
		{
			score = score * this.Const.AI.Behavior.AttackAfterSwitchWeaponMult;
		}

		this.m.TargetTile = bestTarget.Target.getTile();
		return this.Math.max(0, this.Const.AI.Behavior.Score.Attack * bestTarget.Score * score * 10);
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.getAgent().adjustCameraToTarget(this.m.TargetTile);
			this.m.IsFirstExecuted = false;
			return false;
		}

		if (this.m.TargetTile != null && this.m.TargetTile.IsOccupiedByActor)
		{
			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": использует умение '" + this.m.Skill.getName() + "' против врага " + this.m.TargetTile.getEntity().getName() + "!");
			}

			local dist = _entity.getTile().getDistanceTo(this.m.TargetTile);
			this.m.Skill.use(this.m.TargetTile);

			if (_entity.isAlive() && (!_entity.isHiddenToPlayer() || this.m.TargetTile.IsVisibleForPlayer))
			{
				this.getAgent().declareAction();

				if (dist > 1 && this.m.Skill.isShowingProjectile())
				{
					this.getAgent().declareEvaluationDelay(750);
				}
				else if (this.m.Skill.getDelay() != 0)
				{
					this.getAgent().declareEvaluationDelay(this.m.Skill.getDelay());
				}
			}

			this.m.TargetTile = null;
		}

		return true;
	}

});

