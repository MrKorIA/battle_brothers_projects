this.named_rf_poleaxe <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_poleaxe";
		this.m.NameList = ::Const.Strings.SpetumNames;
		this.m.Description = "Этот изящный полэкс создан для пробивания доспехов и шлемов. Он изготовлен мастером, знающим толк в сражениях.";
		this.m.Categories = "Топор, двуручное";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.Value = 4200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 84.0;
		this.m.ConditionMax = 84.0;
		this.m.StaminaModifier = -16;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.3;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_poleaxe_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_poleaxe_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_poleaxe_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		this.addSkill(this.new("scripts/skills/actives/rf_hew_skill"));

		local skill = this.new("scripts/skills/actives/strike_skill");
		skill.m.Icon = "skills/rf_poleaxe_strike_skill.png";
		skill.m.IconDisabled = "skills/rf_poleaxe_strike_skill_sw.png";
		skill.m.Overlay = "rf_poleaxe_strike_skill";
		skill.m.IsIgnoredAsAOO = true;
		this.addSkill(skill);

		skill = this.new("scripts/skills/actives/impale");
		skill.m.Icon = "skills/rf_poleaxe_impale_skill.png";
		skill.m.IconDisabled = "skills/rf_poleaxe_impale_skill_sw.png";
		skill.m.Overlay = "rf_poleaxe_impale_skill";
		skill.m.IsIgnoredAsAOO = true;
		this.addSkill(skill);
	}
});
