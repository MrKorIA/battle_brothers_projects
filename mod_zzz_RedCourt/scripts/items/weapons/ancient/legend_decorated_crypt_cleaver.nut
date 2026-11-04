this.legend_decorated_crypt_cleaver <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		Bravery = 10
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_decorated_crypt_cleaver";
        this.m.Name = "Украшенный тесак из склепа";
        this.m.Description = "Облегчённая церемониальная версия двуручного тесака с изогнутым лезвием, украшенная золотыми инкрустациями и странными узорами.";
		this.m.IconLarge = "weapons/melee/legend_decorated_crypt_cleaver_01.png";
		this.m.Icon = "weapons/melee/legend_decorated_crypt_cleaver_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Cleaver;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsDoubleGrippable = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_decorated_crypt_cleaver_01";
		this.m.Value = 2500;
		this.m.ShieldDamage = 12;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.StaminaModifier = -13;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.2;
		this.m.DirectDamageAdd = 0.15;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local s = this.new("scripts/skills/actives/cleave");
		s.m.FatigueCost = 10;
		this.addSkill(s);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
		s = this.new("scripts/skills/actives/split_shield");
		s.m.FatigueCost = 5;
		this.addSkill(s);
	}
});
