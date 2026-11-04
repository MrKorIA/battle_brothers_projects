this.xx_mob_katar <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xx_mob_katar";
		this.m.Name = "Бандитская катар";
		this.m.Description = "Бандитская катар";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_01";
		this.m.Value = 5000;
		this.m.Condition = 100;
		this.m.ConditionMax = 100;
		this.m.StaminaModifier = 0;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local ww;
		ww = this.new("scripts/skills/actives/xxitem_kataraa_skill");
		ww.m.DirectDamageMult = 0.3;
		this.addSkill(ww);
		ww = this.new("scripts/skills/actives/swing");
		ww.m.FatigueCost = 30;
		ww.m.DirectDamageMult = 0.3;
		this.addSkill(ww);
	}

});

