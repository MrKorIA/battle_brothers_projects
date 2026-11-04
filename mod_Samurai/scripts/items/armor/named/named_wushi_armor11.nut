this.named_wushi_armor11 <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_wushi_armor11";
		this.m.Description = "Доспехи, которые носил знаменитый самурайский генерал.";
		this.m.Name = "Именная броня";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 180;
		this.m.ConditionMax = 180;
		this.m.StaminaModifier = -15;
		this.randomizeValues();
	}
    
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_ armor11_body_" + variant;
		this.m.SpriteDamaged = "bust_wushi_ armor11_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_ armor11_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_wushi_armor11_body_" + variant + ".png";
		this.m.Icon = "armor/icon_wushi_armor11_body_" + variant + ".png";
	}
	
});

