this.named_rf_poleflail <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_poleflail";
		this.m.NameList = ::Const.Strings.TwoHandedFlailNames;
		this.m.Description = "Невозможно спутать с сельскохозяйственным орудием, на основе которого он изготовлен, а прекрасная работа мастера-оружейника очевидна.";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Flail;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.ItemProperty = ::Const.Items.Property.IgnoresShieldwall;
		this.m.IsAgainstShields = true;
		this.m.Value = 4000;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 15;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_poleflail_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_poleflail_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_poleflail_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/rf_flail_pole_skill"));
		this.addSkill(::new("scripts/skills/actives/rf_lash_pole_skill"));
	}
});
