this.cultist_scythe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.cultist_scythe";
		this.m.Name = "Коса культистов";
		this.m.Description = "Ужасная коса, используемая для нанесения глубоких размашистых ударов на расстоянии.";
		this.m.Categories = "Древковое, двуручное";
		this.m.IconLarge = "weapons/melee/bill_01.png";
		this.m.Icon = "weapons/melee/bill_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Cultist;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bill_01";
		this.m.Value = 1400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 62.0;
		this.m.ConditionMax = 62.0;
		this.m.StaminaModifier = -20;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;

		this.m.FatigueOnSkillUse = 3;
		this.setArmament()
	}
	function setArmament()
	{
		local prefix;
		local suffix = this.m.Variant
		local full;
		prefix = "cult_weapon_"
		if (suffix == 0 ){
			suffix = 7
			this.m.Variant = suffix
		}
		if (suffix < 10) suffix = "0"+ suffix
		full = prefix+suffix

		this.m.ArmamentIcon = full
		this.m.Icon = "weapons/melee/" +full+"_icon.png"
		this.m.IconLarge ="weapons/melee/" + full+"_large_icon.png"
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/active_93.png";
		strike.m.IconDisabled = "skills/active_93_sw.png";
		strike.m.Overlay = "active_93";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/reap_skill"));
	}

});

