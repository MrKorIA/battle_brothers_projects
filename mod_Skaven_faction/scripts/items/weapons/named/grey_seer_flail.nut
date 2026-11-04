this.grey_seer_flail <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.grey_seer_flail";
		this.m.Name = "Цеп Серого Провидца";
		this.m.Description = "Этот внушительный двуручный цеп Серого Провидца имеет мало общего с сельскохозяйственным инструментом, от которого он произошёл.";
		this.m.Categories = "Цеп, двуручный";
		this.m.IconLarge = "weapons/melee/grey_seer_flail.png";
		this.m.Icon = "weapons/melee/grey_seer_flail_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_grey_seer_flail";
		this.m.Value = 2800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 15;
		this.randomizeValues();
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/rat_pound");
		skill.m.Icon = "skills/rat_censer_active_01.png";
		skill.m.IconDisabled = "skills/rat_censer_active_01_sw.png";
		skill.m.Overlay = "rat_censer_active_01";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/thresh");
		skill.m.Icon = "skills/rat_censer_active_02.png";
		skill.m.IconDisabled = "skills/rat_censer_active_02_sw.png";
		skill.m.Overlay = "rat_censer_active_02";
		this.addSkill(skill);
	}

});

