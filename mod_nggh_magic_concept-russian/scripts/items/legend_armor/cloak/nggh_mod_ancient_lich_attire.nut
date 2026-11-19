this.nggh_mod_ancient_lich_attire <- ::inherit("scripts/items/legend_armor/legend_armor_upgrade", {
	m = {
		Bravery = 100
	},
	function create()
	{
		this.legend_armor_upgrade.create();
		this.m.Type = ::Const.Items.ArmorUpgrades.Cloak;
		this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.Legendary;
		this.m.ID = "legend_armor.cloak.nggh_ancient_lich_attire";
		this.m.Name = "Древняя накидка первосвященника";
		this.m.Description = "Искусно сотканная и замысловато украшенная накидка, потрёпанная временем. Часть церемониального одеяния первосвященника в древние времена.";
		this.m.ArmorDescription = "Древняя накидка, обеспечивающая дополнительную защиту";
		this.m.SpriteBack = "bust_body_skeleton_80";
		this.m.SpriteDamagedBack = this.m.SpriteBack + "_damaged";
		this.m.SpriteCorpseBack = this.m.SpriteBack + "_dead";
		this.m.Icon = "legend_armor/icon_ancient_lich_attire.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = this.m.Icon;
		this.m.OverlayIconLarge = "legend_armor/inventory_ancient_lich_attire.png";
		this.m.Value = 12000;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.StaminaModifier = 0;
	}

	function getTooltip()
	{
		local result = this.legend_armor_upgrade.getTooltip();
		this.onArmorTooltip(result);
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Повышает вероятность нападения врагов"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт иммунитет к оглушению"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Удваивает решимость при защите от страха и способностей контроля сознания"
			}
		]);
		return _result;
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor_upgrade.onUpdateProperties(_properties);
		_properties.IsImmuneToStun = true;
		_properties.TargetAttractionMult *= 1.2;
		_properties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] *= 2.0;
	}

});
