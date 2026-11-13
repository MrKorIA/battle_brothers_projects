this.rf_poleaxe <- ::inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rf_poleaxe";
		this.m.Name = "Полэкс";
		this.m.Description = "Универсальное и грозное оружие с длинным древком, головкой топора и острием копья, идеально подходящее как для ближнего, так и для дальнего ближнего боя.";
		this.m.Categories = "Топор, двуручное";
		this.m.IconLarge = "weapons/melee/rf_poleaxe_01.png";
		this.m.Icon = "weapons/melee/rf_poleaxe_01_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.ArmamentIcon = "icon_rf_poleaxe_01";
		this.m.Value = 2800;
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
	}

	function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(this.new("scripts/skills/actives/rf_hew_skill"));

		local skill = this.new("scripts/skills/actives/strike_skill");
		skill.m.Icon = "skills/rf_poleaxe_strike_skill.png";
		skill.m.IconDisabled = "skills/rf_poleaxe_strike_skill_sw.png";
		skill.m.Overlay = "rf_poleaxe_strike_skill";
		skill.m.IsIgnoredAsAOO = true;
		this.addSkill(skill);

		local skill = this.new("scripts/skills/actives/impale");
		skill.m.Icon = "skills/rf_poleaxe_impale_skill.png";
		skill.m.IconDisabled = "skills/rf_poleaxe_impale_skill_sw.png";
		skill.m.Overlay = "rf_poleaxe_impale_skill";
		skill.m.IsIgnoredAsAOO = true;
		this.addSkill(skill);
	}
});
