this.mgl_armor_01 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.mgl_armor_01";
		this.m.Name = "Халат";
		this.m.Description = "Длинный халат, который носят пастухи в степях.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 100;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_body_mgl_" + variant;
		this.m.SpriteDamaged = "bust_body_mgl_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_body_mgl_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_bust_body_mgl_" + variant + ".png";
		this.m.Icon = "armor/icon_bust_body_mgl_" + variant + ".png";
	}

});