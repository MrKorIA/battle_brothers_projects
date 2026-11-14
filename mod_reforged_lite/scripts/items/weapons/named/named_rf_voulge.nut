this.named_rf_voulge <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = ::Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_rf_voulge";
		this.m.NameList = ::Const.Strings.CleaverNames;
		this.m.Description = "Клинок этого мастерски выкованного вульжа создан для великих битв, его тяжёлые удары быстро завершат любой поединок.";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Cleaver;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.Value = 4000;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_voulge_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_voulge_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_voulge_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		local weapon = this;
		this.addSkill(::new("scripts/skills/actives/rf_voulge_cleave_skill"));

		local skill = this.new("scripts/skills/actives/rf_gouge_skill");
		skill.m.DirectDamageMult = weapon.m.DirectDamageMult;
		this.addSkill(skill);
	}
});
