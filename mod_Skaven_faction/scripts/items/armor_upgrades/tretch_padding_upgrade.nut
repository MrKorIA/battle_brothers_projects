this.tretch_padding_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.tretch_padding";
		this.m.Name = "Подкладка Треча";
		this.m.Description = "Изготовленная из ржавого металла, эта дополнительная подкладка увеличивает крепость тела.";
		this.m.ArmorDescription = "Подкладка Треча увеличивает крепость тела.";
		this.m.Icon = "armor_upgrades/rat_upgrade_05.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_rat_upgrade_05.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_rat_upgrade_05.png";
		this.m.SpriteFront = "rat_upgrade_05_front";
		this.m.SpriteBack = "rat_upgrade_05_back";
		this.m.SpriteDamagedFront = "rat_upgrade_05_front_damaged";
		this.m.SpriteDamagedBack = "rat_upgrade_05_back";
		this.m.SpriteCorpseFront = "rat_upgrade_05_front_dead";
		this.m.SpriteCorpseBack = "rat_upgrade_05_back_dead";
		this.m.StaminaModifier = 0;
		this.m.Value = 550;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к ОЗ"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к ОЗ"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Hitpoints += 20;
	}

});

