this.niutoukuangzhanshi_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			1
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.niutoukuangzhanshi_helmet";
		this.m.Name = "Шлем";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -5;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_guaishou_01_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_guaishou_01_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_guaishou_01_helmet_0" + this.m.Variant + "_dead";
	}

});

