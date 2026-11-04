this.jinweapon12 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon12";
		this.m.Name = "Боевой топор \'Дафу\'";
        this.m.Description = "Массивный восточный секирный топор сокрушительной мощи. Его широкое тяжёлое лезвие способно с одного яростного взмаха раскалывать щиты и разрубать пополам закованных в латы врагов. Традиционное оружие сотников в армиях Востока.";
		this.m.Categories = "Топор, двуручный";
		this.m.IconLarge = "weapons/melee/jin_weapon_12.png";
		this.m.Icon = "weapons/melee/jin_weapon_12_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_12";
		this.m.Value = 3000;
		this.m.ShieldDamage = 30;
		this.m.Condition = 96.0;
		this.m.ConditionMax = 96.0;
		this.m.StaminaModifier = -30;
		this.m.RegularDamage = 85;
		this.m.RegularDamageMax = 105;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.3;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon12_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon12_02"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

