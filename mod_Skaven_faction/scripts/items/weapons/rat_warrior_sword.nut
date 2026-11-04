this.rat_warrior_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_warrior_sword";
		this.m.Name = "Меч скавенов";
		this.m.Description = "Экзотический изогнутый меч крысиного воина.";
		this.m.Categories = "Меч, одноручный";
		this.m.IconLarge = "weapons/melee/rat_warrior_sword.png";
		this.m.Icon = "weapons/melee/rat_warrior_sword_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_warrior_sword";
		this.m.Value = 900;
		this.m.Condition = 50.0;
		this.m.ConditionMax = 50.0;
		this.m.StaminaModifier = -4;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/slash");
		skill.m.Icon = "skills/rat_sword_active_01.png";
		skill.m.IconDisabled = "skills/rat_sword_active_01_sw.png";
		skill.m.Overlay = "rat_sword_active_01";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/gash_skill");
		this.addSkill(skill);
	}

});

