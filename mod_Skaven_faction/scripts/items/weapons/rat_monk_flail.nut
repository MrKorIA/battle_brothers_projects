this.rat_monk_flail <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_monk_flail";
		this.m.Name = "Чумное кадило скавенов";
		this.m.Description = "Большое и тяжёлое металлическое кадило, для использования которого требуются две руки. Полезно для удара поверх или вокруг щита.";
		this.m.Categories = "Цеп, двуручный";
		this.m.IconLarge = "weapons/melee/rat_monk_flail.png";
		this.m.Icon = "weapons/melee/rat_monk_flail_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_monk_flail";
		this.m.Value = 700;
		this.m.ShieldDamage = 0;
		this.m.Condition = 70.0;
		this.m.ConditionMax = 70.0;
		this.m.StaminaModifier = -15;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 1.10;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 15;
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

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

