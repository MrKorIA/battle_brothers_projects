this.rat_queek_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			1
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.rat_queek_helmet";
		this.m.Name = "Шлем Квика крысы";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 250;
		this.m.ConditionMax = 250;
		this.m.StaminaModifier = -16;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_queek_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_rat_queek_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_rat_queek_helmet_0" + this.m.Variant + "_dead";
	}

});

