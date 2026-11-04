this.xxhat_hunshat <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.xxhat_hunshat";
		this.m.Name = "Шляпа кочевника Востока";
		this.m.Description = "Легкое снаряжение для защиты головы.";
		this.m.IsDroppedAsLoot = true;
		this.m.IsIndestructible = false;
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.Variant = 100;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 50;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		this.m.Sprite = "xxhunshat_" + this.m.Variant;
		this.m.SpriteDamaged = "xxhunshat_" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "xxhunshat_" + this.m.Variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_xxhat_hunshat.png";
	}

});

