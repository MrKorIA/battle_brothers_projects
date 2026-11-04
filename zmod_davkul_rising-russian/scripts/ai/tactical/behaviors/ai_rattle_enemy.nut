this.ai_rattle_enemy <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		PossibleSkills = [
			"actives.rattle"
		],
		Skill = null
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.ModDavkulMancatcherRattle;
		this.m.Order = this.Const.AI.Behavior.Order.ModDavkulMancatcherRattle;
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
			return this.Const.AI.Behavior.Score.Zero;
		}
		local targetEntity = _entity.getSkills().getSkillByID("effects.catching_enemy").m.TargetEntity
		if (targetEntity == null){
			return this.Const.AI.Behavior.Score.Zero;
		}
		this.m.TargetTile = targetEntity.getTile()
		return 99999;
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

