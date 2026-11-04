this.rat_slave_cleaver <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_slave_cleaver";
		this.m.Name = "Ржавый тесак скавенов";
		this.m.Description = "Небольшое заточенное металлическое лезвие клановой крысы.";
		this.m.Categories = "Тесак, одноручный";
		this.m.IconLarge = "weapons/melee/rat_slave_cleaver.png";
		this.m.Icon = "weapons/melee/rat_slave_cleaver_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_slave_cleaver";
		this.m.ShieldDamage = 0;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.StaminaModifier = -5;
		this.m.Value = 100;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.Icon = "skills/rat_cleaver_active_01.png";
		cleave.m.IconDisabled = "skills/rat_cleaver_active_01_sw.png";
		cleave.m.Overlay = "rat_cleaver_active_01";
		this.addSkill(cleave);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

