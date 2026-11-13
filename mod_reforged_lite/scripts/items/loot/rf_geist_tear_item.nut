this.rf_geist_tear_item <- ::inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.rf_geist_tear";
		this.m.Name = "Слеза призрака";
		this.m.Description = "Призрак, покидая сей мир, иногда оставляет за собой драгоценный камень. Мудрецы говорят, что это сама сущность духа, воплощённая в явь.";
		this.m.Icon = "misc/rf_geist_tear.png";
		this.m.SlotType = ::Const.ItemSlot.None;
		this.m.ItemType = ::Const.Items.ItemType.Misc | ::Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 300;
	}

	function getSellPriceMult()
	{
		return ::World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function getBuyPriceMult()
	{
		return ::World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function playInventorySound( _eventType )
	{
		::Sound.play("sounds/combat/armor_leather_impact_03.wav", ::Const.Sound.Volume.Inventory);
	}
});
