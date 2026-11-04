this.xxcape_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.xxcape_upgrade";
		this.m.Name = "Воинская накидка";
		this.m.Description = "Изящная декоративная накидка, надеваемая поверх доспехов. Придает ощущение гордости, шика и обеспечивает дополнительную защиту.";
		this.m.ArmorDescription = "К этой броне прикреплен плащ для дополнительной защиты.";
		this.m.Variant = this.Math.rand(1, 5);
		this.updateVariant();
		this.m.Value = 100;
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		local vv = this.m.Variant;
		this.m.Icon = "armor_upgrades/upg_xxcape_" + vv + ".png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_xxcape_" + vv + ".png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_xxcape_" + vv + ".png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "xxcape_" + vv;
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "xxcape_" + vv;
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
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к прочности"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});

