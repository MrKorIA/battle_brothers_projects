this.sbp_battletrance_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_battletrance_skill";
		this.m.Name = "Боевой транс";
		this.m.Icon = "ui/xxp9.png";
		this.m.Description = "Вы становитесь сильнее после получения большого количества усталости.";
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
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда текущая усталость составляет 80% или более от общей усталости: +8 к защите в ближнем бою, +8 к защите в дальнем бою."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда остаточная усталость составляет 25 или менее: +8 к навыку ближнего боя, +8 к навыку дальнего боя"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "При наличии навыка «Мастерство маны»: +10 ко всем характеристикам"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.getFatiguePct() >= 0.8)
		{
			_properties.MeleeDefense += 8;
			_properties.RangedDefense += 8;
		}
		if (actor.getCurrentProperties().Stamina - actor.getFatigue() <= 25)
		{
			_properties.MeleeSkill += 8;
			_properties.RangedSkill += 8;
		}
		local q = actor.getSkills();
//		if (q.hasSkill("actives.sbp_bondage_skill") && q.hasSkill("actives.sbq1_propaganda_skill"))
		if (q.hasSkill("actives.sbp_bondage_skill"))
		{
			local r = 10;
			_properties.MeleeSkill += r;
			_properties.RangedSkill += r;
			_properties.MeleeDefense += r;
			_properties.RangedDefense += r;
			_properties.Stamina += r;
			_properties.Hitpoints += r;
			_properties.Initiative += r;
			_properties.Bravery += r;
		}
	}

});

