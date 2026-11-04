this.rat_warrior_cleaver <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_warrior_cleaver";
		this.m.Name = "Тесак скавенов";
		this.m.Description = "Большое заточенное металлическое лезвие крысиного воина.";
		this.m.Categories = "Тесак, одноручный";
		this.m.IconLarge = "weapons/melee/rat_warrior_cleaver.png";
		this.m.Icon = "weapons/melee/rat_warrior_cleaver_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_warrior_cleaver";
		this.m.ShieldDamage = 0;
		this.m.Condition = 65.0;
		this.m.ConditionMax = 65.0;
		this.m.StaminaModifier = -10;
		this.m.Value = 1200;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.8;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.Icon = "skills/rat_cleaver_active_02.png";
		cleave.m.IconDisabled = "skills/rat_cleaver_active_02_sw.png";
		cleave.m.Overlay = "rat_cleaver_active_02";
		this.addSkill(cleave);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

