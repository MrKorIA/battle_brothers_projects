this.jinweapon20 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon20";
		this.m.Name = "Тяжёлая алебарда";
		this.m.Description = "Искусно используемая мастерами алебарды, эта тяжёлая алебарда чрезвычайно разрушительна.";
		this.m.Categories = "Древковое оружие, двуручное";
		this.m.IconLarge = "weapons/melee/jin_weapon_20.png";
		this.m.Icon = "weapons/melee/jin_weapon_20_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_20";
		this.m.Value = 5000;
		this.m.ShieldDamage = 30;
		this.m.Condition = 75.0;
		this.m.ConditionMax = 75.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.4;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon20_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon20_02"));
	}

});

