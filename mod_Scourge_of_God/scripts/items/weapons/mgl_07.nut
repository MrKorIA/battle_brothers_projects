this.mgl_07 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.mgl_07";
		this.m.Name = "Хэвтул";
		this.m.Description = "Тяжёлая степная сабля с характерным расширением у конца клинка. Сбалансированная для хлёстких, глубоких рассекающих ударов, она без труда вскрывает кольчуги и лёгкие кожаные доспехи.";
		this.m.Categories = "Меч, одноручный";
		this.m.IconLarge = "weapons/melee/mgl_07.png";
		this.m.Icon = "weapons/melee/mgl_07_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "mgl_07";
		this.m.Value = 850;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -5;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 0.85;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/slash");
		skill.m.Icon = "skills/active_172.png";
		skill.m.IconDisabled = "skills/active_172_sw.png";
		skill.m.Overlay = "active_172";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/gash_skill");
		this.addSkill(skill);
	}

});

