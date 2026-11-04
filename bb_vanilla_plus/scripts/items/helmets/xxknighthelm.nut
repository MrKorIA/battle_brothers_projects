this.xxknighthelm <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.xxknighthelm";
		this.m.Name = "Рыцарский шлем";
		this.m.Description = "Средства защиты головы.";
		this.m.IsDroppedAsLoot = true;
		this.m.IsIndestructible = false;
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = true;
		this.m.HideCorpseHead = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = this.Math.rand(100, 101);
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 50;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -20;
		this.m.Vision = -3;
	}

	function updateVariant()
	{
		this.m.Sprite = "xxknighthelm_" + this.m.Variant;
		this.m.SpriteDamaged = "xxknighthelm_" +this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "xxknighthelm_" + this.m.Variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_xxknighthelm_" + this.m.Variant + ".png";
	}

});

