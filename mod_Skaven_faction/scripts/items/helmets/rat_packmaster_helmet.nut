this.rat_packmaster_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			1
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.rat_packmaster_helmet";
		this.m.Name = "Шлем хозяина стаи крыс";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_packmaster_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_rat_packmaster_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_rat_packmaster_helmet_0" + this.m.Variant + "_dead";
	}

});

