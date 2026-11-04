this.rat_warrior_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.rat_warrior_shield";
		this.m.Name = "Щит скавенов";
		this.m.Description = "Треугольный деревянный щит, покрытый металлом. Лёгкий, но также маленький, обеспечивает небольшую защиту от атак для использующего его человека.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.m.Variant = this.Math.rand(2, 3);
		this.updateVariant();
		this.m.Value = 65;
		this.m.MeleeDefense = 10;
		this.m.RangedDefense = 10;
		this.m.StaminaModifier = -4;
		this.m.Condition = 16;
		this.m.ConditionMax = 16;
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_rat_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_rat_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_rat_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_rat_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_rat_shield_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});

