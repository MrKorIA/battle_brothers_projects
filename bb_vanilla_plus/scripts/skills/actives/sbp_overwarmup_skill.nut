this.sbp_overwarmup_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_overwarmup_skill";
		this.m.Name = "100. Разминка (пассивная)";
		this.m.Icon = "ui/xxp20.png";
		this.m.Description = "+5 ко всем характеристикам. Но не может действовать в течение 1 хода в начале боя.";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ожидание (перк): добавляет +5 к бонусу этого навыка."
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		local rr = 5 + (this.getContainer().getActor().getSkills().hasSkill("perk.anticipation") ? 5 : 0);
		_properties.MeleeSkill += rr;
		_properties.RangedSkill += rr;
		_properties.MeleeDefense += rr;
		_properties.RangedDefense += rr;
		_properties.Stamina += rr;
		_properties.Hitpoints += rr;
		_properties.Initiative += rr;
		_properties.Bravery += rr;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		actor.setActionPoints(0);
		local stun = this.new("scripts/skills/effects/ai_stun_effect");
		actor.getSkills().add(stun);
		stun.setTurns(1);
	}

});

