this.jinweapon15 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon15";
		this.m.Name = "Змеиное копьё";
		this.m.Description = "Очень длинное копьё. Может даже поражать врагов на расстоянии двух клеток. Искусно используется восточными мастерами алебарды.";
		this.m.Categories = "Древковое оружие, двуручное";
		this.m.IconLarge = "weapons/melee/jin_weapon_15.png";
		this.m.Icon = "weapons/melee/jin_weapon_15_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_15";
		this.m.Value = 5400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.StaminaModifier = -20;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon15_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon15_02"));
	}

});

