this.rat_packmaster_whip <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_packmaster_whip";
		this.m.Name = "Хлыст скавенов";
		this.m.Description = "Длинный хлыст с зазубренным наконечником, который может наносить ужасные кровоточащие раны на значительном расстоянии, но неэффективен против брони.";
		this.m.Categories = "Тесак, одноручный";
		this.m.IconLarge = "weapons/melee/rat_packmaster_whip.png";
		this.m.Icon = "weapons/melee/rat_packmaster_whip_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_packmaster_whip";
		this.m.RangeMin = 1;
		this.m.RangeMax = 3;
		this.m.RangeIdeal = 3;
		this.m.Value = 450;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.25;
		this.m.DirectDamageMult = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/whip_skill");
		skill.m.Icon = "skills/rat_whip_active_01.png";
		skill.m.IconDisabled = "skills/rat_whip_active_01_sw.png";
		skill.m.Overlay = "rat_whip_active_01";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/disarm_skill");
		this.addSkill(skill);
	}

});

