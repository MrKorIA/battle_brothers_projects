this.nggh_mod_named_horn_plate_legend_upgrade <- ::inherit("scripts/items/legend_armor/legend_named_armor_upgrade", {
	m = {
		DefaultName = "Роговые пластины",
		SpecialValue = 10
	},
	function create()
	{
		this.legend_named_armor_upgrade.create();
		this.m.ID = "legend_named_armor_upgrade.horn_plate";
		this.m.Type = ::Const.Items.ArmorUpgrades.Attachment;
		this.m.Name = "Роговые пластины";
		this.m.Description = "Эти роговые пластины вырезаны из самого прочного, но гибкого материала, который только может создать природа. Прикреплённые к доспеху, они помогут в отражении ударов.";
		this.m.ArmorDescription = "Роговые пластины обеспечивают дополнительную защиту.";
		this.m.Icon = "armor_upgrades/named_upgrade_22.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_22.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_22.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_22_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_22_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_22_back_dead";
		this.m.Value = 1200;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.ConditionModifier = 25;
		this.m.StaminaModifier = -1;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.m.SpecialValue = ::Math.min(30, ::Math.floor(this.m.SpecialValue * ::Math.rand(120, 145) * 0.01));
		this.m.StaminaModifier = ::Math.min(0, this.m.StaminaModifier + ::Math.rand(0, 2));
		this.m.Condition = ::Math.floor(this.m.Condition * ::Math.rand(115, 150) * 0.01) * 1.0;
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
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Получаемый урон в ближнем бою при попадании в тело уменьшается на [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Получаемый урон в ближнем бою при попадании в тело уменьшается на [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart != ::Const.BodyPart.Body)
			return;

		_properties.DamageReceivedMeleeMult *= 1.0 - this.m.SpecialValue * 0.01;
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

