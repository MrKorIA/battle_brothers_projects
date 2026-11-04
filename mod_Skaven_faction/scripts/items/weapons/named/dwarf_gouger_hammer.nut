this.dwarf_gouger_hammer <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.dwarf_gouger_hammer";
		this.m.Name = "Молот Потрошителя Дварфов";
		this.m.Description = "Это древнее и злобное крысиное оружие было создано, когда крысы сражались, чтобы отвоевать Крайние Горы у Дварфов.";
		this.m.Categories = "Молот, двуручный";
		this.m.IconLarge = "weapons/melee/dwarf_gouger_hammer.png";
		this.m.Icon = "weapons/melee/dwarf_gouger_hammer_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_dwarf_gouger_hammer";
		this.m.Value = 3200;
		this.m.ShieldDamage = 26;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 1.8;
		this.m.DirectDamageMult = 0.5;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 0;
		this.randomizeValues();
	}


	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill = this.new("scripts/skills/actives/smite_skill");
		skill.m.Icon = "skills/rat_hammer_active_01.png";
		skill.m.IconDisabled = "skills/rat_hammer_active_01_sw.png";
		skill.m.Overlay = "rat_hammer_active_01";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/shatter_skill");
		skill.m.Icon = "skills/rat_hammer_active_02.png";
		skill.m.IconDisabled = "skills/rat_hammer_active_02_sw.png";
		skill.m.Overlay = "rat_hammer_active_02";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});

