this.wushiweapon37 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wushiweapon37";
		this.m.Name = "Катана ронина";
		this.m.Description = "Старая катана, принадлежавшая бродячему мастеру без господина. Потёртые ножны и наспех перемотанная походной бечёвкой рукоять скрывают бритвенно-острое, потемневшее от чужой крови лезвие. Одно из наиболее широко используемых оружий ронинов.";
		this.m.Categories = "Меч, одноручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_37.png";
		this.m.Icon = "weapons/melee/wushi_weapon_37_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_37";
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

