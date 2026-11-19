this.niutouguaikandao <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.niutouguaikandao";
		this.m.Name = "Зубчатый клинок";
		this.m.Description = "Жестокое оружие: попадая в рану, причиняет противнику невыносимую боль.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/niutoukuangzhanshikandao.png";
		this.m.Icon = "weapons/melee/niutoukuangzhanshikandao_sw.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "niutouguaikandao";
		this.m.Value = 2600;
		this.m.ShieldDamage = 16;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -28;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.35;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/cleave");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/niutourenkandao01_01");
		this.addSkill(skill);
	}

});

