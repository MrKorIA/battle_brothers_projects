this.xxdress <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.xxdress";
		this.m.Name = "Платье";
		this.m.Description = "Женская одежда. Модная, но не обеспечивающая достаточной защиты.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = this.Math.rand(100, 102);
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 50;
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		local variant = this.m.Variant
		this.m.Sprite = "xxdress_" + variant;
		this.m.SpriteDamaged = "xxdress_" + variant + "_damaged";
		this.m.SpriteCorpse = "";
		this.m.IconLarge = "armor/inventory_xxdress_" + variant + "_b.png";
		this.m.Icon = "armor/inventory_xxdress_" + variant + ".png";
	}

});

