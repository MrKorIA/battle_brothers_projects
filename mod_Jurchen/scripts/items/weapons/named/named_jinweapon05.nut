this.named_jinweapon05 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.named_jinweapon05";
		this.m.NameList = this.Const.Strings.jinweapon05Names;
		this.m.UseRandomName = false;
		this.m.Description = "Тяжёлая булава воинов востока, усеянная ужасными шипами. Враг, поражённый этим оружием, получит страшные раны.";
		this.m.Categories = "Булава, двуручная";
		this.m.IconLarge = "weapons/melee/named_jin_weapon_05.png";
		this.m.Icon = "weapons/melee/named_jin_weapon_05_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "named_jin_weapon_05";
		this.m.Value = 3600;
		this.m.ShieldDamage = 30;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -18;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon05_01"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

