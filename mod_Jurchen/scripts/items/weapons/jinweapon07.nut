this.jinweapon07 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon07";
		this.m.Name = "Восточная двуручная палица";
		this.m.Description = "Тяжёлая двуручная палица. Очень эффективна против тяжёлых доспехов.";
		this.m.Categories = "Булава, двуручная";
		this.m.IconLarge = "weapons/melee/jin_weapon_07.png";
		this.m.Icon = "weapons/melee/jin_weapon_07_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_07";
		this.m.Value = 1400;
		this.m.ShieldDamage = 10;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -16;
		this.m.RangeMin = 1;
		this.m.RangeMax = 1;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon07_01"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

