this.rf_battle_axe <- ::inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rf_battle_axe";
		this.m.Name = "Боевой топор";
		this.m.Description = "Двуручный топор, предназначенный для нанесения универсальных ударов.";
		this.m.IconLarge = "weapons/melee/rf_battle_axe_01.png";
		this.m.Icon = "weapons/melee/rf_battle_axe_01_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Axe;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.ArmamentIcon = "icon_rf_battle_axe_01";
		this.m.Value = 1950;
		this.m.ShieldDamage = 26;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -14;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.35;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();

		local weapon = this;

		local skill = this.new("scripts/skills/actives/chop");
		skill.m.FatigueCost += 2;
		skill.m.DirectDamageMult = weapon.m.DirectDamageMult;
		this.addSkill(skill);

		local skill = this.new("scripts/skills/actives/split_man");
		skill.m.ActionPointCost -= 1;
		skill.m.DirectDamageMult = weapon.m.DirectDamageMult;
		this.addSkill(skill);

		local skill = this.new("scripts/skills/actives/split_shield");
		this.addSkill(skill);
	}
});
