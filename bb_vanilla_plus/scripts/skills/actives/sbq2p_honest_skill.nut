this.sbq2p_honest_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq2p_honest_skill";
		this.m.Name = "109. Честный нападающий (пассивный)";
		this.m.Icon = "ui/xxp30.png";
		this.m.Description = "Урон увеличен на +30%. Вероятность атаки по голове уменьшена до 0%.";
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
		_properties.DamageTotalMult += 0.3;
		_properties.HitChance[this.Const.BodyPart.Head] *= 0;
	}

});

