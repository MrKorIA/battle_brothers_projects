this.wushiweapon36 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wushiweapon36";
		this.m.Name = "Катана кэнсэя";
		this.m.Description = "Шедевр кузнечного искусства, ковавшийся несколько месяцев из чистейшей тамахаганэ. Сбалансированный до абсолютного совершенства, этот меч кажется невесомым продолжением руки владельца. Одно из наиболее широко используемых оружий Кэнсэйя.";
		this.m.Categories = "Меч, одноручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_36.png";
		this.m.Icon = "weapons/melee/wushi_weapon_36_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_36";
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.StaminaModifier = -7;
		this.m.Value = 1900;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.2;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/wushiweapon32_01"));
		this.addSkill(this.new("scripts/skills/actives/wushiweapon32_02"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

	

});

