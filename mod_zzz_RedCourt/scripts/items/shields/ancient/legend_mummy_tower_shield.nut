this.legend_mummy_tower_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.legend_mummy_tower_shield";
        this.m.Name = "Древний южный башенный щит";
        this.m.Description = "Высокий и тяжёлый южный башенный щит, обеспечивающий надёжную защиту ценой своей громоздкости. Несмотря на узкий профиль, он с лёгкостью укрывает человека целиком.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		local variants = [
			1,
			2,
			3,
			4
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.Value = 850;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 30;
		this.m.StaminaModifier = -30;
		this.m.Condition = 52;
		this.m.ConditionMax = 52;
	}

	function updateVariant()
	{
		this.m.Sprite = "mummy_towershield_0" + this.m.Variant;
		this.m.SpriteDamaged = "mummy_towershield_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "mummy_towershield_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_mummy_towershield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_mummy_towershield_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});

