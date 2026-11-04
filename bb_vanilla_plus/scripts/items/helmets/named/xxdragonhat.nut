this.xxdragonhat <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.xxdragonhat";
		this.m.Name = "Шлем Красного Дракона";
		this.m.Description = "Шлем, украшенный фигуркой красного дракона.";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.Variant = 232;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -15;
		this.m.Vision = -2;
		this.m.UseRandomName = false;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_helmet_xx01";
		this.m.SpriteDamaged = "bust_helmet_xx01_damaged";
		this.m.SpriteCorpse = "bust_helmet_xx01_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_bust_helmet_xx01.png";
	}

});

