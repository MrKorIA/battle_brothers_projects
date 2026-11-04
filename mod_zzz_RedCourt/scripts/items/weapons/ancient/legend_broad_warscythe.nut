this.legend_broad_warscythe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_broad_warscythe";
		this.m.Name = "Древний боевой серп";
        this.m.Description = "Широкий и тяжёлый боевой серп с удлинённым лезвием. Это оружие требует простора для замаха и непросто в обращении, однако сеет такой хаос среди врагов - будь то на двух ногах или на четырёх, - которому нет равных.";
		this.m.Categories = "Тесак/древковое, двуручный";
		this.m.IconLarge = "weapons/melee/legend_broad_warscythe_01.png";
		this.m.Icon = "weapons/melee/legend_broad_warscythe_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Cleaver | this.Const.Items.WeaponType.Polearm;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_broad_warscythe_01";
		this.m.Value = 1400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 45.0;
		this.m.ConditionMax = 45.0;
		this.m.StaminaModifier = -18;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 105;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.DirectDamageAdd = 0.05;
		this.m.ChanceToHitHead = 5;
		this.m.FatigueOnSkillUse = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/legend_scythe_cleave_skill"));
		this.addSkill(this.new("scripts/skills/actives/reap_skill"));
	}

});