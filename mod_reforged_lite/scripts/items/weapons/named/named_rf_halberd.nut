this.named_rf_halberd <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = ::Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_rf_halberd";
		this.m.NameList = ::Const.Strings.AxeNames;
		this.m.Description = "Лезвие этой искусно выкованной алебарды создано для сражений, его мощь позволяет завершить бой одним ударом.";
		this.m.Categories = "Древковое/Молот, двуручное";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.Value = 4600;
		this.m.ShieldDamage = 0;
		this.m.Condition = 84.0;
		this.m.ConditionMax = 84.0;
		this.m.StaminaModifier = -18;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_halberd_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_halberd_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_halberd_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/rf_halberd_impale_skill"));
		this.addSkill(::new("scripts/skills/actives/rf_halberd_sunder_skill"));

		local skill = this.new("scripts/skills/actives/demolish_armor_skill");
		skill.m.Icon = "skills/rf_halberd_demolish_armor_skill.png";
		skill.m.IconDisabled = "skills/rf_halberd_demolish_armor_skill_sw.png";
		skill.m.Overlay = "rf_halberd_demolish_armor_skill";
		this.addSkill(skill);
	}
});
