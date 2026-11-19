this.mod_ghost_mage_boss_racial <- ::inherit("scripts/skills/skill", {
	m = {
		TimesWaited = 0
	},
	function create()
	{
		this.m.ID = "racial.ghost_boss";
		this.m.Name = "ХЗ";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = ::Const.SkillType.Racial;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 5;
		_properties.DamageRegularMax += 5;

		if (this.getContainer().getActor().getHitpointsPct() <= 0.5)
		{
			_properties.DamageReceivedRegularMult *= 0.7;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null) return;

		if (_targetEntity.getSkills().hasSkill("perk.nimble"))
		{
			_properties.DamageTotalMult *= 1.5;
		}

		if (_targetEntity.getSkills().hasSkill("perk.legend_ubernimble"))
		{
			_properties.DamageTotalMult *= 1.5;
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.getContainer().getActor().spawnMiasmaOn(_targetEntity.getTile(), true);
	}

	function onTurnStart()
	{
		this.m.TimesWaited = 0;
	}

	function onResumeTurn()
	{
		if (++this.m.TimesWaited <= 1 && this.getContainer().getActor().getActionPoints() >= 4)
		{
			this.getContainer().getActor().setWaitActionSpent(false);
		}
	}

	function onTurnEnd()
	{
		::Time.scheduleEvent(::TimeUnit.Virtual, 30, this.shuffleIllusion.bindenv(this), 0);
	}

	function onAfterDamageReceived()
	{
		::Time.scheduleEvent(::TimeUnit.Virtual, 30, this.shuffleIllusion.bindenv(this), null);
	}

	function shuffleIllusion( _damageHitpoints )
	{
		local actor = this.getContainer().getActor();
		local count = actor.getGhostIllusionNumMax();
		local hp = actor.getHitpoints();

		// teleport away
		local b = actor.getAIAgent().getBehavior(70);
		b.onEvaluate(actor, true);
		b.onExecute(actor);

		foreach (a in ::Tactical.Entities.getAllInstancesAsArray())
		{
			if (!a.getFlags().has("illusion"))
			{
				continue;
			}
			
			local b = a.getAIAgent().getBehavior(70);
			a.setHitpoints(hp);
			b.onEvaluate(a, true);
			b.onExecute(a);
			--count;
		}

		local b = actor.getAIAgent().getBehavior(85);
		for (local i = 0; i < count; ++i)
		{
			b.onEvaluate(actor, true);
			b.onExecute(actor);
		}
	}
 
});

