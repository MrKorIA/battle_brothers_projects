this.jinweapon03 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon03";
		this.m.Name = "Яньюэ дао";
		this.m.Description = "Восточный очень тяжёлый и длинный палаш, без должной силы им трудно орудовать.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/jin_weapon_03.png";
		this.m.Icon = "weapons/melee/jin_weapon_03_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_03";
		this.m.Value = 2600;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.3;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon03_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon03_02"));
	}

});

