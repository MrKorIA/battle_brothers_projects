this.rf_draugr_runic_metal_armor <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_draugr_runic_metal_armor";
		this.m.Name = "Рунный металлический доспех курганника";
		this.m.Description = "Толстые, грубые и перекрывающие друг друга металлические пластины поверх кожаной основы, сплошь покрытые рунами, дают хорошую, но очень тяжёлую защиту.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_draugr_armor_12";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 550;
		this.m.Condition = 105;
		this.m.ConditionMax = 105;
		this.m.StaminaModifier = -12;
	}
});
