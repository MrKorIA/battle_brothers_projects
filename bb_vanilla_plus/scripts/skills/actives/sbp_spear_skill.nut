this.sbp_spear_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_spear_skill";
		this.m.Name = "106. Стальной шип (пассивный)";
		this.m.Icon = "ui/xxp4.png";
		this.m.Description = "+15 к навыку ближнего боя и защите, когда у вас есть \'Стена копьев\' или \'Контратака\' бафф";
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
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		local k = this.getContainer().getActor().getSkills();
		if (k.hasSkill("effects.spearwall") || k.hasSkill("effects.riposte"))
		{
			_properties.MeleeSkill += 15;
			_properties.MeleeDefense += 15;
		}
	}

});

