this.wolfrat_tail_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.wolfrat_tail";
		this.m.Name = "Необычный хвост волкокрыса";
		this.m.Description = "Длинный и маленький хвост волкокрыса, который можно выгодно продать на рынке.";
		this.m.Icon = "misc/inventory_wolfrat_tail.png";
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

