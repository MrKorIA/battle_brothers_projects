this.rat_slave_spear <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_slave_spear";
		this.m.Name = "Копьё скавенов";
		this.m.Description = "Простое деревянное копьё клановой крысы.";
		this.m.Categories = "Копьё, одноручное";
		this.m.IconLarge = "weapons/melee/rat_slave_spear.png";
		this.m.Icon = "weapons/melee/rat_slave_spear_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_slave_spear";
		this.m.Value = 140;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -5;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 25;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local thrust = this.new("scripts/skills/actives/thrust");
		thrust.m.Icon = "skills/rat_spear_active_01.png";
		thrust.m.IconDisabled = "skills/rat_spear_active_01_sw.png";
		thrust.m.Overlay = "rat_spear_active_01";
		this.addSkill(thrust);
		local spearwall = this.new("scripts/skills/actives/spearwall");
		spearwall.m.Icon = "skills/rat_spear_active_02.png";
		spearwall.m.IconDisabled = "skills/rat_spear_active_02_sw.png";
		spearwall.m.Overlay = "rat_spear_active_02";
		this.addSkill(spearwall);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

