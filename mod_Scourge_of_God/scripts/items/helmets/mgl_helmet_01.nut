this.mgl_helmet_01 <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.mgl_helmet_01";
		this.m.Name = "Шлем степного воина";
		this.m.Description = "Шлем, носимый степным воином.";
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.IsDroppedAsLoot = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 2000;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -6;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_helmet_mgl_" + variant;
		this.m.SpriteDamaged = "bust_helmet_mgl_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_helmet_mgl_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_bust_helmet_mgl_" + variant + ".png";
	}
	
});

