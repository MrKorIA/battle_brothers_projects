this.tiefutu4_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.tiefutu4_helmet";
		this.m.Name = "Шлем иноземного воеводы";
		this.m.Description = "Шлем, подобный железной башне, плотно облегает голову. На востоке его называют \'тефуту\'.";
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = true;
		this.m.HideCorpseHead = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.IsDroppedAsLoot = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 3500;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -22;
		this.m.Vision = -3;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_jin_helmet4_" + variant;
		this.m.SpriteDamaged = "bust_jin_helmet4_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_jin_helmet4_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_jin_helmet4_" + variant + ".png";
	}

});

