this.rf_foreign_plate_harness <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_foreign_plate_harness";
		this.m.Name = "Чужеземный латный доспех";
		this.m.Description = "Прекрасный латный доспех из далёких земель, обеспечивающий лучшую подвижность по сравнению с местными работами. Один из самых дорогих доспехов, который можно купить за золото.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_foreign_plate_harness"
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 12000;
		this.m.Condition = 360;
		this.m.ConditionMax = 360;
		this.m.StaminaModifier = -46;
	}
});
