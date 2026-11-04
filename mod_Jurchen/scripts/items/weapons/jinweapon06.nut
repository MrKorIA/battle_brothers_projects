this.jinweapon06 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon06";
		this.m.Name = "Восточный палаш";
		this.m.Description = "Палаш воинов востока, предназначенный для рубящих ударов.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/jin_weapon_06.png";
		this.m.Icon = "weapons/melee/jin_weapon_06_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_06";
		this.m.Value = 2600;
		this.m.ShieldDamage = 16;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -18;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon06_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon06_02"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

