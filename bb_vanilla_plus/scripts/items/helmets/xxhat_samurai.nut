this.xxhat_samurai <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.xxhat_samurai";
		this.m.Name = "Шлем самурая";
		this.m.Description = "Нарядный шлем для защиты головы.";
		this.m.IsDroppedAsLoot = true;
		this.m.IsIndestructible = false;
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 232;
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
		this.m.Sprite = "bust_helmet_xx03";
		this.m.SpriteDamaged = "bust_helmet_xx03_damaged";
		this.m.SpriteCorpse = "bust_helmet_xx03_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_bust_helmet_xx03.png";
	}

});

