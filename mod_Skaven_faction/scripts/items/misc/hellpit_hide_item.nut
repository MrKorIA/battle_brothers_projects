this.hellpit_hide_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.hellpit_hide";
		this.m.Name = "Шкура Мерзости Адской Ямы";
		this.m.Description = "Шкура - основа большинства доспехов, и эта толстая шкура, снятая с Мерзости Адской Ямы, особенно прочна.";
		this.m.Icon = "misc/inventory_hellpit_skin.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2400;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});

