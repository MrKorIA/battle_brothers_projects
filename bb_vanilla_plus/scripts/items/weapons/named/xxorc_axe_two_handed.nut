this.xxorc_axe_two_handed <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.xxorc_axe_two_handed";
		this.m.Name = "Убийца огров";
		this.m.Description = "Жестоко массивное, грубое и злобное кованое оружие из железа. Слишком тяжелое, чтобы его мог эффективно использовать обычный человек.";
		this.m.Categories = "Axe, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.IsAoE = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3500;
		this.m.ShieldDamage = 50;
		this.m.Condition = 90;
		this.m.ConditionMax = 90;
		this.m.StaminaModifier = -30;
		this.m.RegularDamage = 110;
		this.m.RegularDamageMax = 130;
		this.m.ArmorDamageMult = 1.7;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 5;
		this.m.FatigueOnSkillUse = 5;
		this.m.IconLarge = "xx_weapon_24.png";
		this.m.Icon = "xx_weapon_24_70x70.png";
		this.m.ArmamentIcon = "icon_xx_weapon_24";
		this.randomizeValues();
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/split_man");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_axe");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/round_swing");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setApplyAxeMastery(true);
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});

