this.ratorge_bones_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.ratorge_bones";
		this.m.Name = "Череп и Кости крысоогра";
		this.m.Description = "Эти крупные кости, взятые у крысоогра, - ценный трофей среди охотников на зверей.";
		this.m.Icon = "misc/inventory_ratorge_bone.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1125;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});

