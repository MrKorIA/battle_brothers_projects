this.named_rf_estoc <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_estoc";
		this.m.NameList = ::Const.Strings.FencingSwordNames;
		this.m.Description = "Хорошо выкованный эсток требует длины и прочности, совмещённой с лёгкостью, дабы наносить быстрые и ловкие удары. Этот клинок - один из лучших образцов, которые вы когда-либо видели.";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Sword;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.Value = 4200;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.3;
		this.m.DirectDamageMult = 0.25;
		this.m.DirectDamageAdd = 0.35;
		this.m.ChanceToHitHead = -25;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_estoc_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_estoc_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_estoc_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		local skill = this.new("scripts/skills/actives/rf_sword_thrust_skill");
		skill.m.FatigueCost += 2;
		this.addSkill(skill);

		this.addSkill(this.new("scripts/skills/actives/lunge_skill"));

		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}
});
