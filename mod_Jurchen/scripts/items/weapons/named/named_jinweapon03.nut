this.named_jinweapon03 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.named_jinweapon03";
		this.m.NameList = this.Const.Strings.jinweapon03Names;
		this.m.UseRandomName = false;
		this.m.Description = "Восточный длинный и тяжёлый палаш, без достаточной силы им трудно орудовать.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/named_jin_weapon_03.png";
		this.m.Icon = "weapons/melee/named_jin_weapon_03_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "named_jin_weapon_03";
		this.m.Value = 3800;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.3;
		this.m.DirectDamageMult = 0.3;
		this.randomizeValues();
	}
	
	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon03_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon03_02"));
	}

});

