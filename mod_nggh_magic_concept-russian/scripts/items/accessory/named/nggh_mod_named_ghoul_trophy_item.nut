this.nggh_mod_named_ghoul_trophy_item <- ::inherit("scripts/items/accessory/named/nggh_mod_named_accessory", {
	m = {},
	function create()
	{
		this.m.Bravery = 4;
		this.m.DamageMult = 1.05;
		this.nggh_mod_named_accessory.create();
		this.m.ID = "accessory.named_ghoul_trophy";
		this.m.Name = "Ожерелье жестоких чудовищ";
		this.m.DefaultName = "Трофейное ожерелье";
		this.m.Description = "Это ожерелье, изготовленное из частей тел самых мощнейших нахцереров, украшает лишь шеи прошедших через множество битв со сверхъестественными ночными хищниками - тех, кого невозможно испугать.";
		this.m.Icon = "accessory/named_nachzehrer_trophy.png";
		this.m.Sprite = "nachzehrer_trophy";
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
			icon = "ui/icons/bravery.png",
			text = "Уменьшает на [color=" + ::Const.UI.Color.NegativeValue + "]-3[/color] решимость любого противника, вступающего с персонажем в ближний бой"
		});
		return result;
	}

	/*
	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}
	*/

	function onUpdateProperties( _properties )
	{
		this.nggh_mod_named_accessory.onUpdateProperties(_properties);
		_properties.Threat += 3;
	}

	function onDeserialize( _in )
	{
		this.nggh_mod_named_accessory.onDeserialize(_in);

		if (this.m.DamageMult > 1.1)
			this.m.DamageMult = 1.1;
	}

});

