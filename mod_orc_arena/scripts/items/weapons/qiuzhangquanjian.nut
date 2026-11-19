this.qiuzhangquanjian <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.qiuzhangquanjian";
		this.m.Name = "Кулаки Телтру";
		this.m.Description = "Телтру предпочитает сражаться, словно зверь. С этим оружием на руках он разрывает врагов, точно дикий хищник.";
		this.m.Categories = "Кинжал, двуручный";
		this.m.IconLarge = "weapons/melee/qiuzhangquanjian.png";
		this.m.Icon = "weapons/melee/qiuzhangquanjian_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "qiuzhangquanjian";
		this.m.Value = 2400;
		this.m.Condition = 90.0;
		this.m.ConditionMax = 90.0;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
	    this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/qiuzhangquanjian01_01"));
	}

});

