this.xxmonkrobe <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.xxmonkrobe";
		this.m.Name = "Касая";
		this.m.Description = "Одежда, которую носят медитаторы Востока";
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.Variant = this.Math.rand(100, 102);
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 50;
		this.m.Condition = 20;
		this.m.ConditionMax = 20;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		local variant = this.m.Variant
		this.m.Sprite = "xxcloth_" + variant;
		this.m.SpriteDamaged = "xxcloth_" + variant + "_damaged";
		this.m.SpriteCorpse = "";
		this.m.IconLarge = "";
		this.m.Icon = "armor/inventory_xxcloth_" + variant + ".png";
	}

});

