this.named_jinweapon15 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.named_jinweapon15";
		this.m.NameList = this.Const.Strings.jinweapon15Names;
		this.m.UseRandomName = false;
		this.m.Description = "Очень длинное змеиное копьё, способное поражать врагов на расстоянии двух клеток. Очень лёгкое. В руках мастера копья это грозное оружие.";
		this.m.Categories = "Древковое оружие, двуручное";
		this.m.IconLarge = "weapons/melee/named_jin_weapon_15.png";
		this.m.Icon = "weapons/melee/named_jin_weapon_15_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "named_jin_weapon_15";
		this.m.Value = 6200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 70.0;
		this.m.ConditionMax = 70.0;
		this.m.StaminaModifier = -18;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon15_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon15_02"));
	}

});

