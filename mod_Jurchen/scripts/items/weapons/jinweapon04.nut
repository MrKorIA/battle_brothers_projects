this.jinweapon04 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon04";
		this.m.Name = "Восточный тяжёлый топор";
		this.m.Description = "Тяжёлый боевой топор воинов востока. Требует огромной силы, поэтому обычно его используют только воеводы в иноземной армии.";
		this.m.Categories = "Топор, двуручный";
		this.m.IconLarge = "weapons/melee/jin_weapon_04.png";
		this.m.Icon = "weapons/melee/jin_weapon_04_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_04";
		this.m.Value = 3000;
		this.m.ShieldDamage = 30;
		this.m.Condition = 96.0;
		this.m.ConditionMax = 96.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 80;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.3;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/jinweapon04_01"));
		this.addSkill(this.new("scripts/skills/actives/jinweapon04_02"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

