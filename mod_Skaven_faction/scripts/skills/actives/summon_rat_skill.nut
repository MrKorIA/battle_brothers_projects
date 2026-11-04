this.summon_rat_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.summon_rat";
		this.m.Name = "Призыв крысы";
		this.m.Description = "Слыша призыв к битве, крысиные стаи кишат из каждой трещины и расщелины, чтобы пожирать своих врагов.";
		this.m.Icon = "skills/summon_rat_active.png";
		this.m.IconDisabled = "skills/summon_rat_active_sw.png";
		this.m.Overlay = "summon_rat_active";
		this.m.SoundOnUse = [
			"sounds/enemies/rat_spell.wav"
		];
		this.m.SoundVolume = 2.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 20;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.summon_rat");
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.summon_rat"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/summon_rat_effect"));
			return true;
		}

		return false;
	}

});

