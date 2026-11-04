this.xxhat_hairband <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.xxhat_hairband";
		this.m.Name = "Повязка на голову";
		this.m.Description = "Толстый кусок ткани, обернутый вокруг головы.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		local variants = [
			99,
			100,
			101
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
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
		this.m.Sprite = "bust_xxhairband_" + this.m.Variant;
		this.m.SpriteDamaged = "bust_xxhairband_" + this.m.Variant;
		this.m.SpriteCorpse = "";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_bust_xxhairband_" + this.m.Variant + ".png";
	}

});

