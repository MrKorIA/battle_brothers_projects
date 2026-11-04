this.wushiweapon06 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wushiweapon06";
		this.m.Name = "Вакидзаси ";
		this.m.Description = "Одно из наиболее широко используемых оружий ниндзя.";
		this.m.Categories = "Тесак, одноручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_06.png";
		this.m.Icon = "weapons/melee/wushi_weapon_06_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_06";
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -7;
		this.m.Value = 1900;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/cleave"));
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

