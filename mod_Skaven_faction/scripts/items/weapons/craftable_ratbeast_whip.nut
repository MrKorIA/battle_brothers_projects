this.craftable_ratbeast_whip <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.craftable_ratbeast_whip";
		this.m.Name = "Хлыст из хвоста зверя скавенов";
		this.m.Description = "Длинный хлыст с зазубренным наконечником, который может наносить ужасные чумные раны на значительном расстоянии, но неэффективен против брони.";
		this.m.Categories = "Тесак, одноручный";
		this.m.IconLarge = "weapons/melee/rat_beast_whip.png";
		this.m.Icon = "weapons/melee/rat_beast_whip_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_beast_whip";
		this.m.RangeMin = 1;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.Value = 550;
		this.m.Condition = 45;
		this.m.ConditionMax = 45;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 10;
		this.m.RegularDamageMax = 25;
		this.m.ArmorDamageMult = 0.25;
		this.m.DirectDamageMult = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/ratbeast_whip_skill");
		skill.m.Icon = "skills/rat_whip_active_02.png";
		skill.m.IconDisabled = "skills/rat_whip_active_02_sw.png";
		skill.m.Overlay = "rat_whip_active_02";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/ratbeast_disarm_skill");
		this.addSkill(skill);
	}

});

