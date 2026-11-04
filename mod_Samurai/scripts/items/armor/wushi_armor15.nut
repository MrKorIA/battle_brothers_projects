this.wushi_armor15 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.wushi_armor15";
		this.m.Name = "Одежда ронина";
		this.m.Description = "Одежда, которую носят некоторые ронины, на вид лёгкая, но под ней скрывается прочная броня.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 500;
		this.m.Condition = 100;
		this.m.ConditionMax = 100;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_ armor15_body_" + variant;
		this.m.SpriteDamaged = "bust_wushi_ armor15_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_ armor15_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_wushi_armor15_body_" + variant + ".png";
		this.m.Icon = "armor/icon_wushi_armor15_body_" + variant + ".png";
	}
});