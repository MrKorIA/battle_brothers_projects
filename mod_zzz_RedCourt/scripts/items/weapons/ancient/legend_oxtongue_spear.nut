this.legend_oxtongue_spear <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_oxtongue_spear";
        this.m.Name = "Древнее копьё \'Воловьий язык\'";
        this.m.Description = "Двулезвийное копьё с обтекаемым, но широким по сравнению с другими копьями профилем. Оно превосходно пробивает доспехи, оставаясь при этом достаточно лёгким для манёвренного боя.";
		this.m.IconLarge = "weapons/melee/legend_oxtongue_spear_01.png";
		this.m.Icon = "weapons/melee/legend_oxtongue_spear_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Spear;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_oxtongue_spear_01";
		this.m.Value = 1050;
		this.m.Condition = 45.0;
		this.m.ConditionMax = 45.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/thrust"));
		this.addSkill(this.new("scripts/skills/actives/legend_heartseeker_skill"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

});

