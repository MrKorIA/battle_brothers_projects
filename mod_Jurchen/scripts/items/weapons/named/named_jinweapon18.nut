this.named_jinweapon18 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.named_jinweapon18";
		this.m.NameList = this.Const.Strings.jinweapon18Names;
		this.m.Description = "Очень тяжёлая алебарда, способная наносить врагам сокрушительный урон. Используется лучшими мастерами алебарды в мире.";
		this.m.Categories = "Древковое оружие, двуручное";
		this.m.IconLarge = "weapons/melee/named_jin_weapon_18.png";
		this.m.Icon = "weapons/melee/named_jin_weapon_18_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "named_jin_weapon_18";
		this.m.Value = 5600;
		this.m.ShieldDamage = 30;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 0;
		this.randomizeValues();
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon18_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon18_02"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});