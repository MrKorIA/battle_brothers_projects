this.bear_hide_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.bear_hide";
		this.m.Name = "Накидка из шкуры медведя";
		this.m.Description = "Накидка из грубой цепи и медвежьего меха. Добавляет непробиваемости носителю.";
		this.m.ArmorDescription = "К этой броне прикреплена накидка из грубой цепи и медвежьего меха, благодаря чему добавляет живучести носителю, прочности доспехов и здоровью носителю брони.";
		this.m.Variant = this.Math.rand(1, 5);
//		this.m.SpriteFront = null;
//		this.m.SpriteDamagedFront = null;
		this.m.SpriteCorpseFront = null;
		this.updateVariant();
		this.m.ConditionModifier = 20;
		this.m.Value = 750;
		this.m.StaminaModifier = 4;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] ОЗ"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к прочности"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-4[/color] к выносливости"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] ОЗ, [color=" + this.Const.UI.Color.NegativeValue + "]-4[/color] к выносливости"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Hitpoints += 10;
	}

	function updateVariant()
	{
//		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		local variant = "01";
		this.m.SpriteFront = "bear_upgrade_front";
		this.m.SpriteBack = "bear_upgrade_back";
		this.m.SpriteDamagedFront = "bear_upgrade_front_damaged";
		this.m.SpriteDamagedBack = "bear_upgrade_back_damaged";
		this.m.SpriteCorpseBack = "bear_upgrade_back_dead";
		this.m.Icon = "armor_upgrades/bear_upgrade.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_fur_cloak" + "_" + variant + ".png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_fur_cloak" + "_" + variant + ".png";
	}

});

