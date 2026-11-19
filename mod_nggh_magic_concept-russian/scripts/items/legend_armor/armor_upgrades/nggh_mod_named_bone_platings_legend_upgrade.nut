this.nggh_mod_named_bone_platings_legend_upgrade <- ::inherit("scripts/items/legend_armor/legend_named_armor_upgrade", {
	m = {
		DefaultName = "Костяные пластины",
		SpecialValue = 1
	},
	function create()
	{
		this.legend_named_armor_upgrade.create();
		this.m.ID = "legend_named_armor_upgrade.bone_platings";
		this.m.Type = ::Const.Items.ArmorUpgrades.Attachment;
		this.m.Name = "Костяные пластины";
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
		this.m.Value = 850;
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = -2;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.m.SpecialValue = ::Math.rand(1, 100) <= 50 ? ::Math.rand(1, 3) : ::Math.rand(1, 2);
		this.m.StaminaModifier = ::Math.min(0, this.m.StaminaModifier + ::Math.rand(0, 1));

		local max = this.m.SpecialValue >= 2 ? 133 : 200;
		local min = this.m.SpecialValue >= 2 ? 115 : 150;
		this.m.Condition = ::Math.floor(this.m.Condition * ::Math.rand(min, max) * 0.01) * 1.0;
		this.m.ConditionMax = this.m.Condition;
	}

	function setName( _prefix = "" )
	{
		if (this.m.DefaultName.len() == 0)
		{
			this.m.Name = _prefix;
			return;
		}

		if (_prefix.len() == 0)
		{
			this.m.Name = this.m.DefaultName;
			return;
		}

		this.m.Name = _prefix + " " + this.m.DefaultName;
	}

	function getTooltip()
	{
		local result = this.legend_named_armor_upgrade.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может полностью поглотить " + (this.m.SpecialValue > 1 ? " до [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "[/color] ударов" : "[color=" + ::Const.UI.Color.NegativeValue + "]1[/color] удара") + ", если только повреждения не нанесёны непосредственно по ОЗ."
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может полностью поглотить " + (this.m.SpecialValue > 1 ? " до [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "[/color] ударов" : "[color=" + ::Const.UI.Color.NegativeValue + "]1[/color] удара") + ", если только повреждения не нанесёны непосредственно по ОЗ."
		});
	}

	function onCombatStarted()
	{
		local bone_plating = ::new("scripts/skills/effects/nggh_mod_bone_plating_effect");
		bone_plating.setCount(this.m.SpecialValue);
		this.addSkill(bone_plating);
	}

	function onSerialize( _out )
	{
		_out.writeI16(this.m.SpecialValue);
		this.legend_named_armor_upgrade.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		if (::Nggh_MagicConcept.Mod.Serialization.isSavedVersionAtLeast("3.0.0-beta.76", _in.getMetaData()))
			this.m.SpecialValue = _in.readI16();
	
		this.legend_named_armor_upgrade.onDeserialize(_in);
	}


});

