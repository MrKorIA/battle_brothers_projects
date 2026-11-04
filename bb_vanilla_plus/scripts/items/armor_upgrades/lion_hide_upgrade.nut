this.lion_hide_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.lion_hide";
		this.m.Name = "Накидка из шкуры льва";
		this.m.Description = "Накидка, изготовленная из красивых шкур кошек. Дает преимущество в инициативе, прочности доспехов и здоровью носителю накидки.";
		this.m.ArmorDescription = "К этой броне прикреплена накидка из шкуры кошачьих, благодаря чему дает преимущество в инициативе, прочности доспехов и здоровью носителю брони.";
		this.m.Icon = "armor_upgrades/leon_upgrade.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_leon_upgrade.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_leon_upgrade.png";
		this.m.SpriteFront = "leon_upgrade_front";
		this.m.SpriteBack = "leon_upgrade_back";
		this.m.SpriteDamagedFront = "leon_upgrade_front_damaged";
		this.m.SpriteDamagedBack = "leon_upgrade_back_damaged";
		this.m.SpriteCorpseFront = "leon_upgrade_front_dead";
		this.m.SpriteCorpseBack = "leon_upgrade_back_dead";
		this.m.ConditionModifier = 10;
		this.m.Value = 750;
		this.m.StaminaModifier = 2;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] ОЗ"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к прочности"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] к выносливости"
		});
		result.push({
			id = 16,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к инициативе"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] ОЗ, [color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] к выносливости, [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к инициативе"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Hitpoints += 10;
		_properties.Initiative += 10;
	}

});

