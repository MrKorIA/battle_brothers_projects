this.wushi_helmet17 <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.wushi_helmet17";
		this.m.Name = "Шлем Сёгуна";
		this.m.Description = "Шлем, который носит Сёгун Востока.";
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
		this.m.Value = 1500;
		this.m.Condition = 190;
		this.m.ConditionMax = 190;
		this.m.StaminaModifier = -10;
		this.m.Vision = -2;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_helmet17_" + variant;
		this.m.SpriteDamaged = "bust_wushi_helmet17_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_helmet17_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_wushi_helmet17_" + variant + ".png";
	}
});

