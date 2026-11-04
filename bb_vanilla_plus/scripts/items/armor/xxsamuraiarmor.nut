this.xxsamuraiarmor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.xxsamuraiarmor";
		this.m.Name = "Броня самурая";
		this.m.Description = "Тяжелая броня, защищающая тело";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 101;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 50;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -38;
	}

	function updateVariant()
	{
		local variant = this.m.Variant
		this.m.Sprite = "xxarmor_" + variant;
		this.m.SpriteDamaged = "xxarmor_" + variant + "_damaged";
		this.m.SpriteCorpse = "xxarmor_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_xxarmor_" + variant + "_b.png";
		this.m.Icon = "armor/inventory_xxarmor_" + variant + ".png";
	}

});

