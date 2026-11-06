this.sbp_maso_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_maso_skill";
		this.m.Name = "Мазохизм";
		this.m.Icon = "ui/xxp11.png";
		this.m.Description = "Этот персонаж наслаждается своей болью и становится сильнее при получения урона.";
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
			id = 3,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Ваш урон увеличивается на 120% пропорционально потерянному ОЗ."
		});
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда у вас кровотечение: +5 к навыку ближнего и дальнего боя"
		});
//		ret.push({
//			id = 5,
//			type = "text",
//			icon = "ui/icons/special.png",
//			text = "Когда ваш бэкграунд \'Бичеватель\': +5 к навыку ближнего и дальнего боя"
//		});
		return ret;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local rr = 1 - actor.getHitpointsPct();
		rr = rr * 1.2;
		if (rr > 0)
		{
			_properties.DamageTotalMult += rr;
		}
		if (actor.getSkills().hasSkill("effects.bleeding"))
		{
			_properties.MeleeSkill += 5;
			_properties.RangedSkill += 5;
		}
		if (actor.getSkills().hasSkill("background.flagellant"))
		{
			_properties.MeleeSkill += 5;
			_properties.RangedSkill += 5;
		}
	}

});

