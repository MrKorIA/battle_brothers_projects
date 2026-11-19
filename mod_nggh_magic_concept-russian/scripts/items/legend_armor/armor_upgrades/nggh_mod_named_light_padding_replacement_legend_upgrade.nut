this.nggh_mod_named_light_padding_replacement_legend_upgrade <- ::inherit("scripts/items/legend_armor/legend_named_armor_upgrade", {
	m = {
		DefaultName = "Шёлковый подбой",
		SpecialValue = 40,
		PreviousValue = 0
	},
	function create()
	{
		this.legend_named_armor_upgrade.create();
		this.m.ID = "legend_named_armor_upgrade.light_padding_replacement";
		this.m.Type = ::Const.Items.ArmorUpgrades.Attachment;
		this.m.Name = "Лёгкий подбой";
		this.m.Description = "Этот подбой, созданный из необычных материалов, предоставляет ту же защиту при меньшем весе.";
		this.m.ArmorDescription = "Подбой этого доспеха заменён на более лёгкий, но столь же прочный.";
		this.m.Icon = "armor_upgrades/named_upgrade_05.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_05.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_05.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_05_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_05_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_05_back_dead";
		this.m.Value = 5000;
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = 0;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.m.SpecialValue = ::Math.min(55, ::Math.floor(this.m.SpecialValue * ::Math.rand(105, 130) * 0.01));
		this.m.StaminaModifier = ::Math.min(0, this.m.StaminaModifier + ::Math.rand(0, 2));
		this.m.Condition = ::Math.floor(this.m.Condition * ::Math.rand(115, 133) * 0.01) * 1.0;
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
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Уменьшает штраф к выносливости брони на [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Уменьшает штраф к выносливости брони на [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "%[/color]"
		});
	}

	function onEquip()
	{
		this.m.StaminaModifier = -::Math.floor(this.m.Armor.getStaminaModifier() * this.m.SpecialValue * 0.01);
		this.legend_armor_upgrade.onEquip();
	}

	function onUnequip()
	{
		this.m.StaminaModifier = 0;
		this.legend_armor_upgrade.onUnequip();
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

