this.rf_brigandine_armor <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_brigandine_armor";
		this.m.Name = "Бригандина с кольчугой";
		this.m.Description = "Суконная основа с вшитыми и заклёпанными перекрывающимися стальными пластинами, надетая поверх длинной кольчуги. Обеспечивает отличную защиту при небольшой потере подвижности.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_brigandine_armor"
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 4600;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -26;
	}
});
