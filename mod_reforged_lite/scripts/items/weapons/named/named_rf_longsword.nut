this.named_rf_longsword <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {
		StunChance = 0
	},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_longsword";
		this.m.NameList = ::Const.Strings.RF_LongswordNames;
		this.m.Description = "Этот изысканный клинок отличается непревзойдённым качеством. Лезвие поёт, рассекая воздух.";
		this.m.Categories = "Меч, двуручное";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.Value = 4000;
		this.m.ShieldDamage = 12;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_longsword_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_longsword_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_longsword_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		local skill = this.new("scripts/skills/actives/overhead_strike");
		skill.setStunChance(this.m.StunChance);
		this.addSkill(skill);

		this.addSkill(this.new("scripts/skills/actives/split"));

		this.addSkill(this.new("scripts/skills/actives/swing"));

		skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}
});
