this.legend_mummy_shield <- this.inherit("scripts/items/shields/shield", {
	m = {
		PrimaryOffhandAttack = null
		},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.legend_mummy_shield";
        this.m.Name = "Древний южный щит";
        this.m.Description = "Небольшой щит из дерева, укреплённый бронзой. Время не пощадило его - древесина стала хрупкой, но он всё ещё остаётся лёгким и удобным инструментом для блокирования ударов.";
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
		this.m.Value = 200;
		this.m.MeleeDefense = 8;
		this.m.RangedDefense = 8;
		this.m.StaminaModifier = -6;
		this.m.Condition = 26;
		this.m.ConditionMax = 26;
	}

	function updateVariant()
	{
		this.m.Sprite = "mummy_shield_0" + this.m.Variant;
		this.m.SpriteDamaged = "mummy_shield_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "mummy_shield_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_mummy_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_mummy_shield_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
		this.addSkill(this.new("scripts/skills/actives/legend_buckler_bash_skill"));
	}

	function onUnequip ()
	{
		shield.onUnequip();
		m.PrimaryOffhandAttack = null;
	}

	function getPrimaryOffhandAttack ()
	{
		return m.PrimaryOffhandAttack;
	}

});

