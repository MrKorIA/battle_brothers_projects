this.stronghold_well_fed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Bonus = 0,
		TimeRemaining = 0,
	},
	function create()
	{
		this.m.ID = "effects.stronghold_well_fed";
		this.m.Name = "Сытый";
		this.m.Icon = "skills/stronghold_well_fed.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_143";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Этот персонаж чувствует себя энергичным после правильного питания.";
	}

	function getBonus()
	{
		return this.m.Bonus;
	}

	function setTimeRemaining(_int)
	{
		this.m.TimeRemaining = _int;
	}

	function getTimeRemaining()
	{
		return this.m.TimeRemaining;
	}

	function getTooltip()
	{
		local bonus = this.getBonus();
		local timeRemaining = this.getTimeRemaining();
		local timeText = "Пройдёт за " + timeRemaining + " дня(ей).";
		if (timeRemaining == 1)
			 timeText = "Пройдёт до завтра.";
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
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "[/color] к решимости"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "[/color] к ОЗ"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "[/color] к выносливости"
			},
			{
				id = 6,
				type = "hint",
				icon = "ui/icons/action_points.png",
				text = timeText,
			},
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		local bonus = this.getBonus();
		_properties.Bravery += bonus;
		_properties.Hitpoints  += bonus;
		_properties.Stamina  += bonus;
	}

	function onNewDay()
	{
		this.m.TimeRemaining -= 1;
		if (this.m.TimeRemaining == 0)
			this.removeSelf()
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.TimeRemaining);
		_out.writeU8(this.m.Bonus);
	}

	function onDeserialize( _in )
	{
		this.m.TimeRemaining = _in.readU8();
		this.m.Bonus = _in.readU8();
	}

});

