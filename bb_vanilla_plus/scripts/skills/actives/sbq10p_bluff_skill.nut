this.sbq10p_bluff_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq10p_bluff_skill";
		this.m.Name = "117. Тактический Блеф (пассивный)";
		this.m.Icon = "ui/xxp32.png";
		this.m.Description = "На 30% меньше получаемого урона и +30 к решимости в течение первых 3 ходов.";
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
		if (this.Tactical.isActive() && this.Time.getRound() <= 3)
		{
			_properties.DamageReceivedTotalMult *= 0.7;
			_properties.Bravery += 30;
		}
	}

});

