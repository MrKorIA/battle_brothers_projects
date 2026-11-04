this.dwarf_gouger_blade <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.dwarf_gouger_blade";
		this.m.Name = "Клинок Потрошителя Дварфов";
		this.m.Description = "Это древнее и злобное крысиное оружие было создано, когда крысы сражались, чтобы отвоевать Крайние Горы у Дварфов.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/dwarf_gouger_blade.png";
		this.m.Icon = "weapons/melee/dwarf_gouger_blade_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_dwarf_gouger_blade";
		this.m.Value = 3200;
		this.m.ShieldDamage = 16;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -14;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.25;
	}


	function onEquip()
	{
		this.named_weapon.onEquip();
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

