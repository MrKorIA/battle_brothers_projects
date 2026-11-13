this.rf_half_closed_sallet_with_bevor <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_half_closed_sallet_with_bevor";
		this.m.Name = "Салад с бувигером";
		this.m.Description = "Умело выкованный салад в паре с не менее прекрасным бувигером. Дорогой шлем, обладать которым могут лишь богачи.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_half_closed_sallet_with_bevor"
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5000;
		this.m.Condition = 315;
		this.m.ConditionMax = 315;
		this.m.StaminaModifier = -20;
		this.m.Vision = -3;
	}
});
