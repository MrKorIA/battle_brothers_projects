this.guerdanfazhang <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.guerdanfazhang";
		this.m.Name = "Костяной посох";
		this.m.Description = "Странный посох из кости.";
		this.m.Categories = "Булава, двуручная";
		this.m.IconLarge = "weapons/melee/guerdanfazhuang.png";
		this.m.Icon = "weapons/melee/guerdanfazhuang_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "guerdanfazhang";
		this.m.Value = 2400;
		this.m.ShieldDamage = 80;
		this.m.Condition = 30.0;
		this.m.ConditionMax = 30.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 5;
		this.m.RegularDamageMax = 10;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/guerdanfazhang01_01"));
	}

});

