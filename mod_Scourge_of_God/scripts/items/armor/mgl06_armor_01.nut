this.mgl06_armor_01 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.mgl06_armor_01";
		this.m.Name = "Тяжёлый степной ламелляр";
		this.m.Description = "Тяжёлый ламеллярный доспех кэшиков Орды. Усиленный массивными коваными наплечниками, нагрудными бляхами-зеркалами и плотным мехом, этот доспех превращает своего владельца в ходячую крепость.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 1500;
		this.m.Condition = 260;
		this.m.ConditionMax = 260;
		this.m.StaminaModifier = -32;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_body_mgl06_" + variant;
		this.m.SpriteDamaged = "bust_body_mgl06_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_body_mgl06_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_bust_body_mgl06_" + variant + ".png";
		this.m.Icon = "armor/icon_bust_body_mgl06_" + variant + ".png";
	}

});