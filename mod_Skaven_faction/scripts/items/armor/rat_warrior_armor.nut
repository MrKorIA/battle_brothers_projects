this.rat_warrior_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		local variants = [
			1,
			2,
			3
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.body.rat_warrior_armor";
		this.m.Name = "Броня воина скавенов";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_warrior_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_rat_warrior_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_rat_warrior_armor_0" + this.m.Variant + "_dead";
	}

});

