this.named_mgl08_armor_01 <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_mgl08_armor_01";
		this.m.Description = "Степной ламеллярный доспех, покрытый мехом, принадлежащий, без сомнения, самому отважному из степных воинов.";
		this.m.Name = "Доспех багатура";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -28;
		this.randomizeValues();
	}
    
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_body_mgl08_" + variant;
		this.m.SpriteDamaged = "bust_body_mgl08_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_body_mgl08_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_bust_body_mgl08_" + variant + ".png";
		this.m.Icon = "armor/icon_bust_body_mgl08_" + variant + ".png";
	}
	
});

