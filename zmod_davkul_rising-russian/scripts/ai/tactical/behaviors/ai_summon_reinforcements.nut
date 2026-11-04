this.ai_summon_reinforcements <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		PossibleSkills = [
			"actives.summon_reinforcements"
		],
		Skill = null

	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.ModDavkulHighPriestReinforcements;
		this.m.Order = this.Const.AI.Behavior.Order.ModDavkulHighPriestReinforcements;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.Skill = null;
		local scoreMult = 0
		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null || this.m.Skill.m.Cooldown != 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local myTile = _entity.getTile();
		local potentialDanger = this.getPotentialDanger(true);
		local currentDanger = 0.0;
		yield null;

		foreach( t in potentialDanger )
		{
			local d = this.queryActorTurnsNearTarget(t, myTile, _entity);

			if (d.Turns <= 1.0)
			{
				currentDanger = currentDanger + (1.0 - d.Turns);
			}
		}
		
		return 10000;
	}

	function onBeforeExecute( _entity )
	{
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.getAgent().adjustCameraToTarget(_entity.getTile());
			this.m.IsFirstExecuted = false;
			return false;
		}

		this.m.Skill.use(_entity.getTile());

		if (!_entity.isHiddenToPlayer())
		{
			this.getAgent().declareAction();
			this.getAgent().declareEvaluationDelay(1500);
		}
		this.m.Skill = null;
		return true;
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


	function selectSkill( _potentialSkills )
	{
		local entity = this.getAgent().getActor();
		local skills = [];
		local chance = 0;

		foreach( skillID in _potentialSkills )
		{
			local skill = entity.getSkills().getSkillByID(skillID);


			if (skill != null && skill.isUsable() && skill.isAffordable())
			{
				local thisChance = 0;
				thisChance = thisChance + 3 * (entity.getActionPoints() - skill.getActionPointCost());
				thisChance = thisChance + (entity.getFatigueMax() - skill.getFatigueCost() * entity.getCurrentProperties().FatigueEffectMult);
				chance = chance + thisChance;
				skills.push(skill);
			}
		}

		if (skills.len() == 0)
		{
			return null;
		}
		else if (skills.len() == 1)
		{
			return skills[0];
		}

		local pick = this.Math.rand(1, chance);

		foreach( skill in skills )
		{
			local thisChance = 0;
			thisChance = thisChance + 3 * (entity.getActionPoints() - skill.getActionPointCost());
			thisChance = thisChance + (entity.getFatigueMax() - skill.getFatigueCost() * entity.getCurrentProperties().FatigueEffectMult);

			if (pick <= thisChance)
			{
				return skill;
			}

			pick = pick - thisChance;
		}
		return null;
	}

});

