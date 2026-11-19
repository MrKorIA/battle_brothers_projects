this.nggh_mod_named_bone_platings_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.bone_platings";
		this.m.DefaultName = "Костяные пластины";
		this.m.Description = "Изготовленные из прочных, но удивительно лёгких костей, эти пластины можно носить как украшение поверх обычного доспеха.";
		this.m.ArmorDescription = "Этот доспех украшен костяными пластинами.";
		this.m.Icon = "armor_upgrades/named_upgrade_06.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_06.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_06.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_06_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_06_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_06_back_dead";
		this.m.Value = 2000;
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = -2;
		this.m.SpecialValue = 1;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.m.StaminaModifier = ::Math.min(0, this.m.StaminaModifier + ::Math.rand(0, 1));
		this.m.ConditionModifier = ::Math.floor(this.m.ConditionModifier * ::Math.rand(115, 140) * 0.01) * 1.0;
		this.m.SpecialValue = ::Math.rand(1, 100) <= 50 ? ::Math.rand(1, 3) : ::Math.rand(1, 2);
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
				id = 14,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color] к выносливости"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может полностью поглотить " + (this.m.SpecialValue > 1 ? " до [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "[/color] ударов" : "[color=" + ::Const.UI.Color.NegativeValue + "]1[/color] удара") + ", если только повреждения не нанесёны непосредственно по ОЗ"
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
			text = "Может полностью поглотить " + (this.m.SpecialValue > 1 ? " до [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "[/color] ударов" : "[color=" + ::Const.UI.Color.NegativeValue + "]1[/color] удара") + ", если только повреждения не нанесёны непосредственно по ОЗ"
		});
	}

	function onCombatStarted()
	{
		local bone_plating = ::new("scripts/skills/effects/nggh_mod_bone_plating_effect");
		bone_plating.setCount(this.m.SpecialValue);
		this.addSkill(bone_plating);
	}

});

