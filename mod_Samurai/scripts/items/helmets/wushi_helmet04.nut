this.wushi_helmet04 <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.wushi_helmet04";
		this.m.Name = "Маска элитного ниндзя.";
		this.m.Description = "Маска, которую носят элитные ниндзя.";
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
		this.m.Value = 700;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -6;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_helmet04_" + variant;
		this.m.SpriteDamaged = "bust_wushi_helmet04_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_helmet04_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_wushi_helmet04_" + variant + ".png";
	}
});

