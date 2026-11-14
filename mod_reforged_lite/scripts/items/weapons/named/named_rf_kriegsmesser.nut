this.named_rf_kriegsmesser <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_kriegsmesser";
		this.m.NameList = ::Const.Strings.RF_KriegsmesserNames;
		this.m.Description = "Исключительно умело выкованный двуручный тесак, сбалансированный и смертоносный. Он способен наносить глубокие резаные раны, двигаясь с проворством обычного меча.";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Cleaver | ::Const.Items.WeaponType.Sword;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.Value = 3000;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_kriegsmesser_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_kriegsmesser_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_kriegsmesser_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		this.addSkill(this.new("scripts/skills/actives/cleave"));

		this.addSkill(this.new("scripts/skills/actives/decapitate"));

		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}
});
