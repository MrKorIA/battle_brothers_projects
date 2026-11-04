this.xxmstaff <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		LastSkillUse = 0
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxmstaff";
		this.m.Name = "Энергетический посох";
		this.m.Description = "Высокоточное дальнобойное оружие. Оно обнажает слабые места цели.";
		this.m.Categories = "Посох, двуручный";
		this.m.IconLarge = "xx_weapon_04.png";
		this.m.Icon = "xx_weapon_04_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_04";
		this.m.Value = 8000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = -10;
		this.m.RangeMin = 2;
		this.m.RangeMax = 6;
		this.m.RangeIdeal = 6;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 2.0;
		this.m.DirectDamageMult = 0.4;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_mstaffaa_skill"));
	}

});

