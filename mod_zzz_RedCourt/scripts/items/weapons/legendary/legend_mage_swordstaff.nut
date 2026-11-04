this.legend_mage_swordstaff <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_mage_swordstaff";
        this.m.Name = "Магический меч-посох";
        this.m.Description = "Природа создания этого оружия остаётся загадкой, но уникальный меч-посох пронизан магией. Клинок почти поёт в воздухе и рассекает доспехи, словно масло.";
		this.m.IconLarge = "weapons/melee/legend_swordstaff_01_legendary_01.png";
		this.m.Icon = "weapons/melee/legend_swordstaff_01_legendary_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Sword | this.Const.Items.WeaponType.Polearm;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Legendary;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_swordstaff_legendary_01";
		this.m.Value = 20000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 1;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.DirectDamageAdd = 0.3;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
		this.addSkill(this.new("scripts/skills/actives/legend_skewer_skill"));
		this.addSkill(this.new("scripts/skills/actives/lunge_skill"));
	}

});

