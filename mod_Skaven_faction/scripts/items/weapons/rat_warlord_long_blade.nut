this.rat_warlord_long_blade <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_warlord_long_blade";
		this.m.Name = "Клинок скавенов";
		this.m.Description = "Большой, длинный клинок, который крысиный вождь держит двумя руками.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/rat_warlord_long_blade.png";
		this.m.Icon = "weapons/melee/rat_warlord_long_blade_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_warlord_long_blade";
		this.m.Value = 2100;
		this.m.ShieldDamage = 16;
		this.m.Condition = 55.0;
		this.m.ConditionMax = 55.0;
		this.m.StaminaModifier = -15;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.Icon = "skills/rat_blade_active_01.png";
		cleave.m.IconDisabled = "skills/rat_blade_active_01_sw.png";
		cleave.m.Overlay = "rat_blade_active_01";
		cleave.m.FatigueCost = 15;
		this.addSkill(cleave);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});

