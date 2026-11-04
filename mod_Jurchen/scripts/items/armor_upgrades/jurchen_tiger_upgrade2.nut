this.jurchen_tiger_upgrade2 <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.jurchen_tiger2";
		this.m.Name = "Большой львиный наплечник";
		this.m.Description = "Большой наплечник, крепящийся на правое плечо.";
		this.m.ArmorDescription = "Большой львиный наплечник закреплён на этом доспехе.";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 300;
		this.m.ConditionModifier = 20
		this.m.StaminaModifier = 2;
	}

	function updateVariant()
	{
		this.m.Icon = "armor_upgrades/upgrade_jurchen_tiger.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_jurchen_tiger2.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_jurchen_tiger2.png";
		this.m.SpriteFront = "jurchen_tiger_upgrade_front";
		this.m.SpriteBack = null;
		this.m.SpriteDamagedFront = "jurchen_tiger_upgrade_front_damaged";
		this.m.SpriteDamagedBack = null;
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = null;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к прочности"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] к выносливости"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});

