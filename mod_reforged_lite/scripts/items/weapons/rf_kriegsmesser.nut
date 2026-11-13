this.rf_kriegsmesser <- ::inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rf_kriegsmesser";
		this.m.Name = "Гросс-мессер";
		this.m.Description = "Отличный двуручный тесак, способный наносить глубокие резаные раны, двигаясь с проворством обычного меча.";
		this.m.IconLarge = "weapons/melee/rf_kriegsmesser_01.png";
		this.m.Icon = "weapons/melee/rf_kriegsmesser_01_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Cleaver | ::Const.Items.WeaponType.Sword;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.ArmamentIcon = "icon_rf_kriegsmesser_01";
		this.m.Value = 2400;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(this.new("scripts/skills/actives/cleave"));

		this.addSkill(this.new("scripts/skills/actives/decapitate"));

		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}
});
