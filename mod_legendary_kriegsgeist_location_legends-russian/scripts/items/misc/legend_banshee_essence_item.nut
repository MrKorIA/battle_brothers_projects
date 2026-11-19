this.legend_banshee_essence_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.legend_banshee_essence";
		this.m.Name = "Эссенция баньши";
		this.m.Description = "Остатки испарившейся баньши. Если прислушаться, то из банки до сих пор слышно, как она всхлипывает. Может заинтересовать особо извращённых покупателей.";
		this.m.Icon = "misc/inventory_banshee_essence.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});

