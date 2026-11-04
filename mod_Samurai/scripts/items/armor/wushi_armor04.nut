this.wushi_armor04 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.wushi_armor04";
		this.m.Name = "Костюм ниндзя";
		this.m.Description = "Чёрная одежда помогала ниндзя оставаться незаметными в бою.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 700;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -10;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_ armor04_body_" + variant;
		this.m.SpriteDamaged = "bust_wushi_ armor04_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_ armor04_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_wushi_armor04_body_" + variant + ".png";
		this.m.Icon = "armor/icon_wushi_armor04_body_" + variant + ".png";
	}
});