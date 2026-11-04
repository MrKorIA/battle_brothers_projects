this.rat_assassin_claws <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_assassin_claws";
		this.m.Name = "Когти скавенов";
		this.m.Description = "Длинные, четырёхгранные когти, предназначенные для пронзания слабых мест в броне.";
		this.m.Categories = "Кинжал, одноручный";
		this.m.IconLarge = "weapons/melee/rat_assassin_claws.png";
		this.m.Icon = "weapons/melee/rat_assassin_claws_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_assassin_claws";
		this.m.Condition = 45.0;
		this.m.ConditionMax = 45.0;
		this.m.Value = 400;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/stab");
		skill.m.Icon = "skills/rat_claws_active_01.png";
		skill.m.IconDisabled = "skills/rat_claws_active_01_sw.png";
		skill.m.Overlay = "rat_claws_active_01";
		this.addSkill(skill);
		this.addSkill(this.new("scripts/skills/actives/puncture"));
	}

});

