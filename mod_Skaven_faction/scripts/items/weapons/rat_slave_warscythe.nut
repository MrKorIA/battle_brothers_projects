this.rat_slave_warscythe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_slave_warscythe";
		this.m.Name = "Коса скавенов";
		this.m.Description = "Длинное древко с прикреплённым острым изогнутым лезвием, используемое для нанесения глубоких размашистых ударов на расстоянии.";
		this.m.Categories = "Древковое, двуручное";
		this.m.IconLarge = "weapons/melee/rat_slave_warscythe.png";
		this.m.Icon = "weapons/melee/rat_slave_warscythe_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_slave_warscythe";
		this.m.Value = 450;
		this.m.ShieldDamage = 0;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.StaminaModifier = -11;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 1.05;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/rat_scythe_active_01.png";
		strike.m.IconDisabled = "skills/rat_scythe_active_01_sw.png";
		strike.m.Overlay = "rat_scythe_active_01";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/reap_skill"));
	}

});

