this.rf_heavy_plate_harness <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_heavy_plate_harness";
		this.m.Name = "Тяжёлый латный доспех";
		this.m.Description = "Этот толстый латный доспех обеспечивает практически непревзойдённую защиту при некоторой потере подвижности. Один из самых дорогих доспехов, который можно купить за золото.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_heavy_plate_harness"
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 380;
		this.m.ConditionMax = 380;
		this.m.StaminaModifier = -50;
	}
});
