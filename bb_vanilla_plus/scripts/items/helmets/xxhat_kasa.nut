this.xxhat_kasa <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.xxhat_kasa";
		this.m.Name = "Каса";
		this.m.Description = "Это доспех, защищающий голову от дождя и стрел.";
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
		this.m.Condition = 75;
		this.m.ConditionMax = 75;
		this.m.StaminaModifier = -4;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_helmet_xx02";
		this.m.SpriteDamaged = "bust_helmet_xx02_damaged";
		this.m.SpriteCorpse = "bust_helmet_xx02_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_bust_helmet_xx02.png";
	}

});

