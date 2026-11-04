this.wushi_armor05 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.wushi_armor05";
		this.m.Name = "Костюм элитного ниндзя";
		this.m.Description = "Элитные ниндзя, носившие эти костюмы, были одними из самых опасных убийц с Дальнего Востока.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 1000;
		this.m.Condition = 170;
		this.m.ConditionMax = 170;
		this.m.StaminaModifier = -11;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_ armor05_body_" + variant;
		this.m.SpriteDamaged = "bust_wushi_ armor05_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_ armor05_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_wushi_armor05_body_" + variant + ".png";
		this.m.Icon = "armor/icon_wushi_armor05_body_" + variant + ".png";
	}
});