this.hellpit_tail_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.hellpit_tail";
		this.m.Name = "Хвост Мерзости Адской Ямы";
		this.m.Description = "Длинный хвост Мерзости Адской Ямы - один из самых почётных трофеев, которые охотник на зверей может принести домой из своих приключений.";
		this.m.Icon = "misc/inventory_hellpit_tail.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 3000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});

