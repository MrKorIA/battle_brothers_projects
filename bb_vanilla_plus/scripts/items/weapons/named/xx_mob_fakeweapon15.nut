this.xx_mob_fakeweapon15 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.xx_mob_fakeweapon15";
		this.m.NameList = this.Const.Strings.WhipNames;
		this.m.Description = "fake weapon";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowArmamentIcon = false;
		this.m.RangeMin = 1;
		this.m.RangeMax = 15;
		this.m.RangeIdeal = 15;
		this.m.Value = 0;
		this.m.Condition = 7777;
		this.m.ConditionMax = 7777;
		this.m.StaminaModifier = 0;
		this.m.RegularDamage = 1;
		this.m.RegularDamageMax = 1;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.5;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
	}

});

