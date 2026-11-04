this.wolfrat_pelt_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.wolfrat_pelt";
		this.m.Name = "Плащ из Шкуры волкокрыса";
		this.m.Description = "Шкуры, снятые со свирепых волкокрысов, выделанные и сшитые вместе, чтобы их можно было носить как трофей охотника на зверей на шее. Ношение шкуры такого зверя может превратить человека в внушительную фигуру.";
		this.m.ArmorDescription = "К этой броне прикреплён плащ из шкур волкокрыса, который превращает владельца в внушительную фигуру.";
		this.m.Icon = "armor_upgrades/rat_upgrade_02.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_rat_upgrade_02.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_rat_upgrade_02.png";
		this.m.SpriteFront = "rat_upgrade_02_front";
		this.m.SpriteBack = "rat_upgrade_02_back";
		this.m.SpriteDamagedFront = "rat_upgrade_02_front_damaged";
		this.m.SpriteDamagedBack = "rat_upgrade_02_back";
		this.m.SpriteCorpseFront = "rat_upgrade_02_front_dead";
		this.m.SpriteCorpseBack = "rat_upgrade_02_back_dead";
		this.m.Value = 600;
		this.m.StaminaModifier = 0;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] к ОЗ"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уменьшает решимость любого противника в ближнем бою на [color=" + this.Const.UI.Color.NegativeValue + "]-4[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] к ОЗ"
		});
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уменьшает решимость любого противника в ближнем бою на [color=" + this.Const.UI.Color.NegativeValue + "]-4[/color]"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Threat += 4;
		_properties.Hitpoints += 15;
	}

});

