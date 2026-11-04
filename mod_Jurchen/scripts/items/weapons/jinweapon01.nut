this.jinweapon01 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon01";
		this.m.Name = "Восточная волчья палица";
		this.m.Description = "Эта устрашающая булава, используемая восточными воинами, покрыта шипами.";
		this.m.Categories = "Булава, двуручная";
		this.m.IconLarge = "weapons/melee/jin_weapon_01.png";
		this.m.Icon = "weapons/melee/jin_weapon_01_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_01";
		this.m.Value = 2000;
		this.m.ShieldDamage = 20;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -22;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/jinweapon01_01");
		skill.m.Icon = "skills/jinweapon01_01.png";
		skill.m.IconDisabled = "skills/jinweapon01_01_sw.png";
		skill.m.Overlay = "jinweapon01_01";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});

