this.jinweapon09 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon09";
		this.m.Name = "Тесак \'Чжаньмадао\'";
		this.m.Description = "Массивный восточный двуручный тесак с длинной рукоятью и изогнутым бронебойным клинком. Это грозное оружие создано для борьбы с элитной конницей и способно одним яростным взмахом подрезать ноги боевым скакунам и рассечь всадника вместе с его доспехами.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/jin_weapon_09.png";
		this.m.Icon = "weapons/melee/jin_weapon_09_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_09";
		this.m.Value = 2600;
		this.m.ShieldDamage = 16;
		this.m.Condition = 70.0;
		this.m.ConditionMax = 70.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon09_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon09_02"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

