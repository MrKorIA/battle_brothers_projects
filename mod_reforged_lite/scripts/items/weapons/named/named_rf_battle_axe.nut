this.named_rf_battle_axe <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_battle_axe";
		this.m.NameList = ::Const.Strings.AxeNames;
		this.m.Description = "Умелый кузнец позаботился о том, чтобы этот топор пел при ударах, а его отделка была безупречной.";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Axe;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.Value = 4000;
		this.m.ShieldDamage = 26;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -14;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.35;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_battle_axe_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_battle_axe_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_battle_axe_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

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
