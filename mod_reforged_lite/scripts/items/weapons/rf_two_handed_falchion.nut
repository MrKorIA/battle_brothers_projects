this.rf_two_handed_falchion <- ::inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rf_two_handed_falchion";
		this.m.Name = "Двуручный фальшион";
		this.m.Description = "Более крупный вариант фальшиона, оставляющий глубокие и смертельные раны.";
		this.m.IconLarge = "weapons/melee/rf_two_handed_falchion_01.png";
		this.m.Icon = "weapons/melee/rf_two_handed_falchion_01_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Cleaver | ::Const.Items.WeaponType.Sword;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.ArmamentIcon = "icon_rf_two_handed_falchion_01";
		this.m.Value = 1700;
		this.m.Condition = 56.0;
		this.m.ConditionMax = 56.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();

		local skill = this.new("scripts/skills/actives/cleave");
		skill.m.FatigueCost -= 1;
		this.addSkill(skill);

		local skill = this.new("scripts/skills/actives/decapitate");
		skill.m.FatigueCost -= 2;
		this.addSkill(skill);

		local skill = this.new("scripts/skills/actives/riposte");
		skill.m.FatigueCost -= 3;
		this.addSkill(skill);
	}
});
