this.named_rf_swordstaff <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = ::Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_rf_swordstaff";
		this.m.NameList = ::Const.Strings.SpetumNames;
		this.m.Description = "Умело выкованная глефа, столь же прекрасная, сколь и смертоносная. Этот шедевр станет желанным дополнением к любому отряду наемников.";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Sword | ::Const.Items.WeaponType.Spear;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded | ::Const.Items.ItemType.Defensive;
		this.m.Value = 4200;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -10;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_swordstaff_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_swordstaff_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_swordstaff_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		local prong = ::new("scripts/skills/actives/prong_skill");
		this.addSkill(prong);

		this.addSkill(::new("scripts/skills/actives/rf_overhead_strike_swordstaff_skill"));

		local skill = this.new("scripts/skills/actives/spearwall");
		skill.m.ActionPointCost += 2;
		skill.m.FatigueCost += 5;
		skill.m.Icon = "skills/active_124.png";
		skill.m.IconDisabled = "skills/active_124_sw.png";
		skill.m.Overlay = "active_124";
		skill.m.BaseAttackName = prong.getName();
		this.addSkill(skill);
	}
});
