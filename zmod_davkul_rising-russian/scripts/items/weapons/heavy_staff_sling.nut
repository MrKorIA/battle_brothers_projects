this.heavy_staff_sling <- this.inherit("scripts/items/weapons/staff_sling", {
	m = {},
	function create()
	{
		this.staff_sling.create();
		this.m.ID = "weapon.heavy_staff_sling";
		this.m.Name = "Тяжёлая праща на посохе";
		this.m.Description = "Кожаная праща на посохе, используемая для метания тяжёлых камней во врага.";
		this.m.IconLarge = "weapons/ranged/cult_sling_icon.png";
		this.m.Icon = "weapons/ranged/cult_sling_icon_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ArmamentIcon = "cult_sling";
		this.m.Value = 1000;
		this.m.RangeMax = 5;
		this.m.RangeIdeal = 3;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.45;
		this.m.Condition = 70.0;
		this.m.ConditionMax = 70.0;
		this.m.ShieldDamage = 16;
	}

	function onEquip()
	{
		this.staff_sling.onEquip();
		this.addSkill(this.new("scripts/skills/actives/sling_heavy_stone_skill"));
	}

});

