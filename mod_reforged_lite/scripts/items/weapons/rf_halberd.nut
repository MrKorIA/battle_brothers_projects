this.rf_halberd <- ::inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rf_halberd";
		this.m.Name = "Хальберд";
		this.m.Description = "Длинное древко, пикообразное остриё, лезвие для нанесения ударов издалека и молот для пробития доспехов.";
		this.m.Categories = "Древковое оружие/Молот, двуручное";
		this.m.IconLarge = "weapons/melee/rf_halberd_01.png";
		this.m.Icon = "weapons/melee/rf_halberd_01_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.ArmamentIcon = "icon_rf_halberd_01";
		this.m.Value = 2500;
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
	}

	function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/rf_halberd_impale_skill"));
		this.addSkill(::new("scripts/skills/actives/rf_halberd_sunder_skill"));

		local skill = this.new("scripts/skills/actives/demolish_armor_skill");
		skill.m.Icon = "skills/rf_halberd_demolish_armor_skill.png";
		skill.m.IconDisabled = "skills/rf_halberd_demolish_armor_skill_sw.png";
		skill.m.Overlay = "rf_halberd_demolish_armor_skill";
		this.addSkill(skill);
	}
});
