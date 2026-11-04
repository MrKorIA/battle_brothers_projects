this.jinweapon99 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon99";
		this.m.Name = "0";
		this.m.Description = "0";
		this.m.Categories = "Булава, двуручная";
		this.m.IconLarge = "weapons/melee/jin_weapon_01.png";
		this.m.Icon = "weapons/melee/jin_weapon_01_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_01";
		this.m.Value = 3000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -1;
		this.m.RegularDamage = 0;
		this.m.RegularDamageMax = 2;
		this.m.ArmorDamageMult = 0.1;
		this.m.DirectDamageMult = 0.1;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon99_01"));
		
	}

});

