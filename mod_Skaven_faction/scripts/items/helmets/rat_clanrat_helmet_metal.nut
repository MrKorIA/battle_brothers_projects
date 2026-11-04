this.rat_clanrat_helmet_metal <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			1,
			2
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.rat_clanrat_helmet_metal";
		this.m.Name = "Металлический шлем клановой крысы";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -6;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_clanrat_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_rat_clanrat_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_rat_clanrat_helmet_0" + this.m.Variant + "_dead";
	}

});

