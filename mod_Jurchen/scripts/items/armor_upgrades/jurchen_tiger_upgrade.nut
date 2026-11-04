this.jurchen_tiger_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.jurchen_tiger";
		this.m.Name = "Большие львиные наплечники";
		this.m.Description = "Большие наплечники, крепящиеся на доспех.";
		this.m.ArmorDescription = "Большие наплечники закреплены на этом доспехе.";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 500;
		this.m.ConditionModifier = 40;
		this.m.StaminaModifier = 3;
	}

	function updateVariant()
	{
		this.m.Icon = "armor_upgrades/upgrade_jurchen_tiger.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_jurchen_tiger.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_jurchen_tiger.png";
		this.m.SpriteFront = "jurchen_tiger_upgrade_front";
		this.m.SpriteBack = "jurchen_tiger_upgrade_back";
		this.m.SpriteDamagedFront = "jurchen_tiger_upgrade_front_damaged";
		this.m.SpriteDamagedBack = "jurchen_tiger_upgrade_back_damaged";
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
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+40[/color] к прочности"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-3[/color] к выносливости"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});

