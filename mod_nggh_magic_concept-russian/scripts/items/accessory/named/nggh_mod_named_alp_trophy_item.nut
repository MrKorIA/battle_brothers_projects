this.nggh_mod_named_alp_trophy_item <- ::inherit("scripts/items/accessory/named/nggh_mod_named_accessory", {
	m = {},
	function create()
	{
		this.m.Bravery = 5;
		this.m.Initiative = 10;
		this.m.SpecialValue = 15;
		this.nggh_mod_named_accessory.create();
		this.m.ID = "accessory.named_alp_trophy";
		this.m.Name = "Ожерелье из альпов";
		this.m.DefaultName = "Трофейное ожерелье";
		this.m.Description = "Это ожерелье, изготовленное из частей тел самых могущественных альпов, украшает лишь шеи прошедших через множество битв со сверхъестественными ночными хищниками - тех, кого невозможно испугать.";
		this.m.Icon = "accessory/named_alp_trophy.png";
		this.m.Sprite = "alp_trophy";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 2500;
	}

	function getTooltip()
	{
		local result = this.nggh_mod_named_accessory.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.SpecialValue + "[/color] к решимости при проверках боевого духа против атак с эффектами страха, паники или контроля над сознанием."
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.nggh_mod_named_accessory.onUpdateProperties(_properties);
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += this.m.SpecialValue;
	}

});

