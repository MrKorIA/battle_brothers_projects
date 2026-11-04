this.xxhat_hwaranghat <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.xxhat_hwaranghat";
		this.m.Name = "Шлем Хваранга";
		this.m.Description = "Богато украшенный шлем с перьями по обеим сторонам.";
		this.m.IsDroppedAsLoot = false;
		this.m.IsIndestructible = false;
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 111;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 50;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -5;
	}

	function updateVariant()
	{
		this.m.Sprite = "xxknighthelm_" + this.m.Variant;
		this.m.SpriteDamaged = "xxknighthelm_" + this.m.Variant;
		this.m.SpriteCorpse = "";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_xxknighthelm_" + this.m.Variant + ".png";
	}

});

