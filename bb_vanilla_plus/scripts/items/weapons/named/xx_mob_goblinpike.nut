this.xx_mob_goblinpike <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xx_mob_goblinpike";
		this.m.Name = "Копье гоблина для ближнего боя";
		this.m.Description = "Копье гоблина для ближнего боя";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bladed_pike_01";
		this.m.ShieldDamage = 1;
		this.m.Condition = 70.0;
		this.m.ConditionMax = 70.0;
		this.m.RangeMin = 1;
		this.m.RangeMax = 1;
		this.m.RangeIdeal = 1;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local im = this.new("scripts/skills/actives/rupture");
		im.m.Overlay = "active_04";
		im.m.MaxRange = 1;
		im.m.DirectDamageMult = 0.3;
		this.addSkill(im);
	}

});

