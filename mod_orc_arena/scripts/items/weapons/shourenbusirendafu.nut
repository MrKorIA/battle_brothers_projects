this.shourenbusirendafu <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.shourenbusirendafu";
		this.m.Name = "Топор таурена";
		this.m.Description = "Этот топор настолько тяжёл, что трудно представить, кто способен им орудовать.";
		this.m.Categories = "Топор, двуручный";
		this.m.IconLarge = "weapons/melee/shourenbusirendafu.png";
		this.m.Icon = "weapons/melee/shourenbusirendafu_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "shourenbusirendafu";
		this.m.Value = 2400;
		this.m.ShieldDamage = 80;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -40;
		this.m.RegularDamage = 100;
		this.m.RegularDamageMax = 120;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/split_man"));
		this.addSkill(this.new("scripts/skills/actives/round_swing"));
		this.addSkill(this.new("scripts/skills/actives/shourenbusirendafu01_01"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setApplyAxeMastery(true);
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});

