this.cp_reinforced_wooden_staff <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.cp_reinforced_wooden_staff";
		this.m.Name = "Укреплённый Деревянный Посох";
		this.m.Description = "Крепкий деревянный посох, укреплённый на обоих концах, способный наносить мощные удары с безопасного расстояния.";
		this.m.Categories = "Булава, Двуручный";
		this.m.IconLarge = "weapons/melee/cp_reinforced_wooden_staff_01.png";
		this.m.Icon = "weapons/melee/cp_reinforced_wooden_staff_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.ArmamentIcon = "cp_icon_reinforced_wooden_staff_01";
		this.m.Value = 600;
		this.m.Condition = 44.0;
		this.m.ConditionMax = 44.0;
		this.m.StaminaModifier = -10;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/crumble_skill"));
		this.addSkill(this.new("scripts/skills/actives/knock_over_skill"));
	}
});

