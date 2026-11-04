this.tabard_01_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.tabard_01";
		this.m.Name = "Накидка";
		this.m.Description = "Мерзкая накидка, которую носят культисты";
		this.m.ArmorDescription = "К доспехам прикреплёна тканая накидка.";
		this.m.Icon = "armor_upgrades/upgrade_101.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_101.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_101.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_101_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_101_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_101_back_dead";
		this.m.Value = 200;
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = false;
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

	function updateAppearance( _app )
	{

		_app.ArmorUpgradeFront = this.m.SpriteDamagedFront != null ? this.m.SpriteDamagedFront : this.m.SpriteFront != null ? this.m.SpriteFront : "";
		_app.ArmorUpgradeBack = this.m.SpriteDamagedBack != null ? this.m.SpriteDamagedBack : this.m.SpriteBack != null ? this.m.SpriteBack : "";

		_app.CorpseArmorUpgradeFront = this.m.SpriteCorpseFront != null ? this.m.SpriteCorpseFront : "";
		_app.CorpseArmorUpgradeBack = this.m.SpriteCorpseBack ? this.m.SpriteCorpseBack : "";
	}

	function onUpdateProperties( _properties )
	{
	}

});
