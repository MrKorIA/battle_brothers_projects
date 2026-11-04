this.rat_slave_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		local variants = [
			3
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.body.rat_slave_armor";
		this.m.Name = "Броня крысиного раба";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_slave_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_rat_slave_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_rat_slave_armor_0" + this.m.Variant + "_dead";
	}

});

