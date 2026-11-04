this.legend_great_khopesh <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_great_khopesh";
		this.m.Name = "Большой хопеш";
        this.m.Description = "По весу и размерам это загадочное оружие напоминает ногу крупного зверя - оно столь же огромно, сколь и устрашающе. Внешняя изогнутая кромка клинка наточена до такой остроты, что при замахе рассекает воздух с пронзительным свистом.";
		this.m.IconLarge = "weapons/melee/legend_great_khopesh.png";
		this.m.Icon = "weapons/melee/legend_great_khopesh_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Cleaver;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsDoubleGrippable = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_great_khopesh";
		this.m.ShieldDamage = 0;
		this.m.Condition = 54.0;
		this.m.ConditionMax = 54.0;
		this.m.StaminaModifier = -18;
		this.m.Value = 2000;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.25;
		this.m.FatigueOnSkillUse = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local s = this.new("scripts/skills/actives/cleave");
		s.m.FatigueCost = 15;
		this.addSkill(s);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
	}
});
