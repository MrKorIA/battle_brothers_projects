this.mgl06_helmet_01 <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.mgl06_helmet_01";
		this.m.Name = "Шлем ханской гвардии";
		this.m.Description = "Шлем, который носят гвардейцы хана";
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.IsDroppedAsLoot = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 2000;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -15;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_helmet_mgl06_" + variant;
		this.m.SpriteDamaged = "bust_helmet_mgl06_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_helmet_mgl06_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_bust_helmet_mgl06_" + variant + ".png";
	}

});

