this.nggh_mod_named_direwolf_pelt_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.direwolf_pelt";
		this.m.DefaultName = "Накидка из шкур лютоволков";
		this.m.Description = "Из шкур свирепых лютоволков была пошита накидка, которую можно носить как охотничий трофей. Облачившись в шкуру зверя, можно обрести воистину внушительный вид.";
		this.m.ArmorDescription = "К этой броне прикреплена накидка из шкур лютоволков, придающая владельцу воистину внушительный вид.";
		this.m.Icon = "armor_upgrades/named_upgrade_01.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_01.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_01.png";
		this.m.SpriteFront = "upgrade_01_front";
		this.m.SpriteBack = "upgrade_01_back";
		this.m.SpriteDamagedFront = "upgrade_01_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_01_back";
		this.m.SpriteCorpseFront = "upgrade_01_front_dead";
		this.m.SpriteCorpseBack = "upgrade_01_back_dead";
		this.m.Value = 1000;
		this.m.ConditionModifier = 15;
		this.m.StaminaModifier = 0;
		this.m.SpecialValue = 5;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.nggh_mod_named_armor_upgrade.randomizeValues();
		this.m.SpecialValue = ::Math.min(25, ::Math.ceil(this.m.SpecialValue * ::Math.rand(115, 140) * 0.01));
	}

	function getTooltip()
	{
		local result = this.nggh_mod_named_armor_upgrade.getTooltip();
		result.extend([
			{
				id = 13,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(this.m.ConditionModifier) + "[/color] к прочности"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снижает решимость любого противника, вовлеченного с владельцем в рукопашный бой, на [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "[/color]"
			}
		]);
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Снижает решимость любого противника, вовлеченного с владельцем в рукопашный бой, на [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "[/color]"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.nggh_mod_named_armor_upgrade.onUpdateProperties(_properties);
		_properties.Threat += this.m.SpecialValue;
	}

});

