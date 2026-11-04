this.mgl11_armor_01 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.mgl11_armor_01";
		this.m.Name = "Доспех оркобоя";
		this.m.Description = "После истребления множества орков, головы поверженных врагов вешают на пояс, а плечи защищают оркскими наплечниками. Это дает большое преимущество в бою с орками. Увеличивает урон по оркам на 10%.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 3000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -24;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_body_mgl11_" + variant;
		this.m.SpriteDamaged = "bust_body_mgl11_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_body_mgl11_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_bust_body_mgl_" + variant + ".png";
		this.m.Icon = "armor/icon_bust_body_mgl_" + variant + ".png";
	}
	
});