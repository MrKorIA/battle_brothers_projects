this.rf_kastenbrust_plate_harness <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_kastenbrust_plate_harness";
		this.m.Name = "Коробчатый латный доспех";
		this.m.Description = "Полный латный коробчатый доспех, надеваемый поверх кольчуги. Один из самых дорогих доспехов, который можно купить за золото.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_kastenbrust_plate_harness"
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 10000;
		this.m.Condition = 360;
		this.m.ConditionMax = 360;
		this.m.StaminaModifier = -50;
	}
});
