this.named_wushiweapon38 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_wushiweapon38";
		this.m.Name = "Ронин";
		this.m.Description = "Хорошо сделанное оружие ронина. Самое совершенное оружие мечника-изгоя.";
		this.m.Categories = "Меч, одноручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_38.png";
		this.m.Icon = "weapons/melee/wushi_weapon_38_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ShieldDamage = 0;
		this.m.Condition = 68.0;
		this.m.ConditionMax = 68.0;
		this.m.StaminaModifier = -7;
		this.m.ArmamentIcon = "wushi_weapon_38";
		this.m.Value = 4000;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
		this.randomizeValues();
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/wushiweapon32_01"));
		this.addSkill(this.new("scripts/skills/actives/wushiweapon32_02"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

});

