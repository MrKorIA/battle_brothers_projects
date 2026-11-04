this.ai_damaged_passive <- this.inherit("scripts/skills/skill", {
	//bloodsucker9 liger9 minder9 samurai9
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_damaged_passive";
		this.m.Name = "Ярость";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive() || actor.isDying())
		{
			return;
		}
		if (actor.getFlags().has("riposter"))
		{
			if (!actor.getSkills().hasSkill("effects.riposte"))
			{
				actor.getSkills().add(this.new("scripts/skills/effects/riposte_effect"));
			}
		}
		else if (actor.getFlags().has("liger"))
		{
			if (this.Math.rand(1, 100) <= 25)
			{
				if (!actor.getSkills().hasSkill("effects.killing_frenzy"))
				{
					actor.getSkills().add(this.new("scripts/skills/effects/killing_frenzy_effect"));
				}
				if (!actor.getSkills().hasSkill("effects.indomitable"))
				{
					actor.getSkills().add(this.new("scripts/skills/effects/indomitable_effect"));
				}
			}
		}
		else
		{
			if (!actor.getSkills().hasSkill("effects.killing_frenzy"))
			{
				actor.getSkills().add(this.new("scripts/skills/effects/killing_frenzy_effect"));
			}
		}
	}

});

