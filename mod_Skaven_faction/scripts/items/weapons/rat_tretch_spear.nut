this.rat_tretch_spear <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_trech_spear";
		this.m.Name = "Трезубец скавенов";
		this.m.Description = "Трезубец - копьё с тремя наконечниками, используемое Тречем Трусливым Хвостом.";
		this.m.Categories = "Копьё, одноручное";
		this.m.IconLarge = "weapons/melee/rat_tretch_spear.png";
		this.m.Icon = "weapons/melee/rat_tretch_spear_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_spear_three_headed";
		this.m.Value = 2250;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local thrust = this.new("scripts/skills/actives/thrust");
		thrust.m.Icon = "skills/rat_spear_active_07.png";
		thrust.m.IconDisabled = "skills/rat_spear_active_07_sw.png";
		thrust.m.Overlay = "rat_spear_active_07";
		this.addSkill(thrust);
		local spearwall = this.new("scripts/skills/actives/spearwall");
		spearwall.m.Icon = "skills/rat_spear_active_08.png";
		spearwall.m.IconDisabled = "skills/rat_spear_active_08_sw.png";
		spearwall.m.Overlay = "rat_spear_active_08";
		this.addSkill(spearwall);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

