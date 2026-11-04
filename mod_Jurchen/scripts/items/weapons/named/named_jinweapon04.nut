this.named_jinweapon04 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.named_jinweapon04";
		this.m.NameList = this.Const.Strings.jinweapon04Names;
		this.m.UseRandomName = false;
		this.m.Description = "Длинный двуручный боевой топор, обрушивающийся с огромной силой при каждом ударе и способный легко разрубить человека пополам.";
		this.m.Categories = "Топор, двуручный";
		this.m.IconLarge = "weapons/melee/named_jin_weapon_04.png";
		this.m.Icon = "weapons/melee/named_jin_weapon_04_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "named_jin_weapon_04";
		this.m.Value = 5600;
		this.m.ShieldDamage = 30;
		this.m.Condition = 96.0;
		this.m.ConditionMax = 96.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 80;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 0;
		this.randomizeValues();
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon04_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon04_02"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

