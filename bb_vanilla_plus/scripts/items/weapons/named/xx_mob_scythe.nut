this.xx_mob_scythe <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.xx_mob_scythe";
		this.m.Name = "fake weapon";
		this.m.Description = "fake weapon";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 0;
		this.m.ShieldDamage = 0;
		this.m.Condition = 7777;
		this.m.ConditionMax = 7777;
		this.m.StaminaModifier = 0;
		this.m.RangeMin = 1;
		this.m.RangeMax = 3;
		this.m.RangeIdeal = 3;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.2;
		this.m.ChanceToHitHead = 20;
		this.m.ArmamentIcon = "icon_xx_weapon_11";
		this.randomizeValues();
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/ai_mob_scythe_skill"));
	}

});

