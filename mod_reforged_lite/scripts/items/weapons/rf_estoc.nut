this.rf_estoc <- ::inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rf_estoc";
		this.m.Name = "Эсток";
		this.m.Description = "Длинный двуручный ударный клинок, идеально подходящий для нанесения ударов с выпадом.";
		this.m.IconLarge = "weapons/melee/rf_estoc_01.png";
		this.m.Icon = "weapons/melee/rf_estoc_01_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Sword;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.ArmamentIcon = "icon_rf_estoc_01";
		this.m.Value = 2400;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.3;
		this.m.DirectDamageMult = 0.25;
		this.m.DirectDamageAdd = 0.35; // Brings the total to 60%
		this.m.ChanceToHitHead = -25;
	}

	function onEquip()
	{
		this.weapon.onEquip();

		local skill = this.new("scripts/skills/actives/rf_sword_thrust_skill");
		skill.m.FatigueCost += 2;
		this.addSkill(skill);

		this.addSkill(this.new("scripts/skills/actives/lunge_skill"));

		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}
});
