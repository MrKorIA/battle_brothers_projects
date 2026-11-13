this.rf_brigandine_shirt <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_brigandine_shirt";
		this.m.Name = "Бригандина";
		this.m.Description = "Суконная основа с вшитыми и заклёпанными перекрывающимися стальными пластинами, надеваемая поверх льняной рубахи и стёганки. Обеспечивает хорошую защиту при минимальной потере подвижности.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = ::Math.rand(1, 5);
		this.m.VariantString = "rf_brigandine_shirt"
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3000;
		this.m.Condition = 190;
		this.m.ConditionMax = 190;
		this.m.StaminaModifier = -21;
	}
});
