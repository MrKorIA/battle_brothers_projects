this.vp_vestal_hood <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.vp_vestal_hood";
		this.m.Name = "Капюшон защитницы света";
		this.m.Description = "Качественный капюшон в который облачаются защитницы света.";
		this.m.IsDroppedAsLoot = true;
		this.m.IsIndestructible = false;
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 150;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = 0;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "vestal_hood_" + variant;
		this.m.SpriteDamaged = "vestal_hood_" + variant + "_damaged";
		this.m.SpriteCorpse = "vestal_hood_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/vestal_hood_" + variant + ".png";
	}

});

