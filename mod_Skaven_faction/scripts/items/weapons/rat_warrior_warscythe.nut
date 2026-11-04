this.rat_warrior_warscythe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_warrior_warscythe";
		this.m.Name = "Боевая коса скавенов";
		this.m.Description = "Длинное древко с прикреплённым острым изогнутым лезвием, используемое для нанесения глубоких размашистых ударов на расстоянии.";
		this.m.Categories = "Древковое, двуручные";
		this.m.IconLarge = "weapons/melee/rat_warrior_warscythe.png";
		this.m.Icon = "weapons/melee/rat_warrior_warscythe_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_warrior_warscythe";
		this.m.Value = 650;
		this.m.ShieldDamage = 0;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.05;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/rat_scythe_active_02.png";
		strike.m.IconDisabled = "skills/rat_scythe_active_02_sw.png";
		strike.m.Overlay = "rat_scythe_active_02";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/reap_skill"));
	}

});

