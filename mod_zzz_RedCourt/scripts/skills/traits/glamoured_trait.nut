this.glamoured_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glamoured";
		this.m.Name = "Околдован";
		this.m.Icon = "ui/traits/glamour_trait.png";
		this.m.Description = "Воздействие мощных чар в течение длительного периода времени заставило этого смертного несколько отключиться от реальности. Несмотря на то, что он по-прежнему верен вам, возникли некоторые... побочные эффекты.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;	// back of the line, buddy
	}

	function getTooltip()
	{
		return [
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
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] к наносимому урону в ближнем бою"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+12[/color] к решимости"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] к инициативе"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color] к обзору"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/money2.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]-10%[/color] к ежедневному жалованию"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] к получаемому опыту"
			}
		];
	}

	function onUpdate( _properties ) // in order
	{
		_properties.MeleeDamageMult *= 0.95; //was 0.99?
		_properties.Bravery += 12;
		_properties.Initiative -= 15;
		_properties.Vision -= 1;
		_properties.DailyWage *= 0.90;
		_properties.XPGainMult *= 0.90;
	}

});

