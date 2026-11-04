this.xxhat_hunshelm <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.xxhat_hunshelm";
		this.m.Name = "Восточный шлем";
		this.m.Description = "Средства защиты головы.";
		this.m.IsDroppedAsLoot = true;
		this.m.IsIndestructible = false;
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 110;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 50;
		this.m.Condition = 250;
		this.m.ConditionMax = 250;
		this.m.StaminaModifier = -17;
		this.m.Vision = -2;
	}

	function updateVariant()
	{
		this.m.Sprite = "xxknighthelm_" + this.m.Variant;
		this.m.SpriteDamaged = "xxknighthelm_" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "xxknighthelm_" + this.m.Variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_xxhat_hunshelm.png";
	}

});

