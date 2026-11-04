this.named_jinweapon13 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.named_jinweapon13";
		this.m.NameList = this.Const.Strings.jinweapon13Names;
		this.m.UseRandomName = false;
		this.m.Description = "Чрезвычайно тяжёлая булава, искусно используемая воеводами в восточной армии.";
		this.m.Categories = "Булава, двуручная";
		this.m.IconLarge = "weapons/melee/named_jin_weapon_13.png";
		this.m.Icon = "weapons/melee/named_jin_weapon_13_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "named_jin_weapon_13";
		this.m.Value = 5400;
		this.m.ShieldDamage = 25;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.3;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

    function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon13_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon13_02"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

