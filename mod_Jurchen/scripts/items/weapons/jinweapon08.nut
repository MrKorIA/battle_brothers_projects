this.jinweapon08 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon08";
		this.m.Name = "Тесак \'Чжаньмадао\'";
        this.m.Description = "Массивный восточный двуручный тесак с длинной рукоятью и изогнутым бронебойным клинком. Это грозное оружие создано для борьбы с элитной конницей и способно одним яростным взмахом подрезать ноги боевым скакунам и рассечь всадника вместе с его доспехами.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/jin_weapon_08.png";
		this.m.Icon = "weapons/melee/jin_weapon_08_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_08";
		this.m.Value = 2600;
		this.m.ShieldDamage = 18;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -18;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon08_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon08_02"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

