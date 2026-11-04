this.wolfrat_pelt_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.wolfrat_pelt";
		this.m.Name = "Необычная шкура волкокрыса";
		this.m.Description = "Толстая и необычная шкура волкокрыса, которую можно выгодно продать на рынке.";
		this.m.Icon = "misc/inventory_wolfrat_skin.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});

