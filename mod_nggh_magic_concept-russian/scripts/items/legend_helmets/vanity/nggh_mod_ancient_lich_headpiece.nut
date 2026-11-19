this.nggh_mod_ancient_lich_headpiece <- ::inherit("scripts/items/legend_helmets/legend_helmet_upgrade", {
	m = {},
	function create()
	{
		this.legend_helmet_upgrade.create();
		this.m.Type = ::Const.Items.HelmetUpgrades.Vanity;
		this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.Legendary;
		this.m.ID = "armor.head.nggh_ancient_lich_headpiece";
		this.m.Name = "Головной убор древнего первосвященника";
		this.m.Description = "Хорошо сделанный головной убор с замысловатым декором. Часть церемониального головного убора первосвященника в древние времена.";
		this.m.ArmorDescription = "Головной убор из древних времен обеспечивает как физическую, так и психическую защиту.";
		this.m.Sprite = "bust_helmet_skeleton_82";
		this.m.SpriteDamaged = this.m.Sprite + "_damaged";
		this.m.SpriteCorpse = this.m.Sprite + "_dead";
		this.m.Icon = "legend_helmets/inventory_ancient_lich_headpiece.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = this.m.Icon;
		this.m.OverlayIconLarge = this.m.OverlayIcon;
		this.m.ImpactSound = ::Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = ::Const.Sound.ArmorChainmailImpact;
		this.m.Value = 12000;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.StaminaModifier = 0;
		this.m.Vision = 0;
		this.m.HideHair = true;
	}

	function getTooltip()
	{
		local result = this.legend_helmet_upgrade.getTooltip();
		this.onArmorTooltip(result);
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Позволяет владельцу видеть ночью, снимает все штрафы от эффекта 'Ночное время'."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Повышает вероятность нападения врагов именно на этого персонажа"
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

    function onUpdateProperties(_properties)
    {
    	this.legend_helmet_upgrade.onUpdateProperties(_properties);
  		_properties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] *= 2.0;
  		_properties.IsAffectedByNight = false;
		_properties.TargetAttractionMult *= 1.2;
    }

	function updateVariant()
	{
		//local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
	}
});
