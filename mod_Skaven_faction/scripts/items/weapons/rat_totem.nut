this.rat_totem <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_totem";
		this.m.Name = "Тотем скавенов";
		this.m.Description = "Длинный тотем, используемый для тычковых ударов на расстоянии и удержания врага на расстоянии.";
		this.m.Categories = "Древковое, двуручное";
		this.m.IconLarge = "weapons/melee/rat_totem.png";
		this.m.Icon = "weapons/melee/rat_totem_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "rat_totem_01";
		this.m.Value = 1100;
		this.m.ShieldDamage = 0;
		this.m.Condition = 68.0;
		this.m.ConditionMax = 68.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local impale = this.new("scripts/skills/actives/impale");
		impale.m.Icon = "skills/rat_spear_active_05.png";
		impale.m.IconDisabled = "skills/rat_spear_active_05_sw.png";
		impale.m.Overlay = "rat_spear_active_05";
		this.addSkill(impale);
		local repel = this.new("scripts/skills/actives/repel");
		repel.m.Icon = "skills/rat_spear_active_06.png";
		repel.m.IconDisabled = "skills/rat_spear_active_06_sw.png";
		repel.m.Overlay = "rat_spear_active_06";
		this.addSkill(repel);
	}

});

