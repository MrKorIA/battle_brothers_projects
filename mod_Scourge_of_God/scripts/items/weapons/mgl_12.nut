this.mgl_12 <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.mgl_12";
		this.m.Name = "Тяжёлый Чомар";
		this.m.Description = "Массивная булава с литым стальным шаром на конце. Лишённое изящества, но смертоносное оружие, созданное с одной целью — превращать в кровавое месиво всё, во что прилетит этот пушечный набалдашник.";
		this.m.Categories = "Булава, одноручная";
		this.m.IconLarge = "weapons/melee/mgl_12.png";
		this.m.Icon = "weapons/melee/mgl_12_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "mgl_12";
		this.m.Value = 1800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.4;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local bash = this.new("scripts/skills/actives/bash");
		this.addSkill(bash);
		local knockout = this.new("scripts/skills/actives/knock_out");
		this.addSkill(knockout);
	}

});

