this.xxsteelarmor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.xxsteelarmor";
		this.m.Description = "It is a masterpiece forged from the finest steel by the most outstanding craftsmen.";
		local r = this.Math.rand(1, 2);
		this.m.NameList = [
			"Grand Amor",
			"Grand Plate Amor",
			"Grand Steel Amor"
		];
		local vv = [
			200,
			200,
			201,
			202,
			203,
			204
		];
		this.m.Variant = vv[this.Math.rand(0, vv.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 320;
		this.m.ConditionMax = 320;
		this.m.StaminaModifier = -42;
		this.randomizeValues();
	}

	function updateVariant()
	{
		local vv = this.m.Variant
		this.m.Sprite = "xxarmor_" + vv;
		this.m.SpriteDamaged = "xxarmor_" + vv + "_damaged";
		this.m.SpriteCorpse = "xxarmor_" + vv + "_dead";
		this.m.IconLarge = "armor/inventory_xxarmor_" + vv + "_L.png";
		this.m.Icon = "armor/inventory_xxarmor_" + vv + ".png";
	}

	function createRandomName()
	{
		return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
	}

});

