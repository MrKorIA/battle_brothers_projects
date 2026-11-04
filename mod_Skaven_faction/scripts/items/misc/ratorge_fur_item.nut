this.ratorge_fur_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.ratorge_fur";
		this.m.Name = "Мех крысоогра";
		this.m.Description = "Мех крысоогра с шипами станет впечатляющим и экзотическим дополнением к любой броне наёмника, пусть и не самым изысканным.";
		this.m.Icon = "misc/inventory_ratorge_fur.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1200;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});

