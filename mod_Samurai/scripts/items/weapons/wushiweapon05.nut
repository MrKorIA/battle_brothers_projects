this.wushiweapon05 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wushiweapon05";
		this.m.Name = "Тэккокаги";
		this.m.Description = "Коготь, используемый ниндзя как в качестве оружия, так и для лазания по стенам и крутым склонам.";
		this.m.Categories = "Кинжал, одноручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_05.png";
		this.m.Icon = "weapons/melee/wushi_weapon_05_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_05";
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.Value = 900;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/wushiweapon05_01"));
		this.addSkill(this.new("scripts/skills/actives/wushiweapon05_02"));
	}

});

