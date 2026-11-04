this.sbq13p_rhythm_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq13p_rhythm_skill";
		this.m.Name = "120. Боевой ритм (пассивный)";
		this.m.Icon = "ui/xxp33.png";
		this.m.Description = "Получите +35% урона каждые 3 хода.";
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
		if (this.Time.getRound() % 3 == 0)
		{
			_properties.DamageTotalMult += 0.35;
		}
	}

});

