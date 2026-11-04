this.named_wushiweapon31 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 5);
		this.updateVariant();
		this.m.ID = "weapon.named_wushiweapon31";
		this.m.Name = "Воспламеняющий взрыв";
		this.m.Description = "Тяжелая нодати, принадлежавшая одному из самых свирепых самураев. При использовании этой нодати, вырывается ревущее пламя!";
		this.m.Categories = "Меч, двуручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_31.png";
		this.m.Icon = "weapons/melee/wushi_weapon_31_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_31";
		this.m.Value = 4600;
		this.m.ShieldDamage = 36;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -18;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 10;
		this.randomizeValues();
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/overhead_strike"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
		this.addSkill(this.new("scripts/skills/actives/wushiweapon25_01"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setApplyAxeMastery(true);
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});

