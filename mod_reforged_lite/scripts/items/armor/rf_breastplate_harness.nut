this.rf_breastplate_harness <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_breastplate_harness";
		this.m.Name = "Латный доспех";
		this.m.Description = "Изысканная кираса с латной юбкой, наплечниками, полной защитой рук и дополнительными наплечными щитками. Обеспечивает непревзойдённую защиту для самых богатых воинов.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_breastplate_harness"
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 9000;
		this.m.Condition = 340;
		this.m.ConditionMax = 340;
		this.m.StaminaModifier = -44;
	}
});
