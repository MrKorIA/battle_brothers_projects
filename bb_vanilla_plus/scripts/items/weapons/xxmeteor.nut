this.xxmeteor <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxmeteor";
		this.m.Name = "Метеоритный молот";
		this.m.Description = "Оружие с железными шарами на концах обеих веревок. Имеет большой радиус действия.";
		this.m.Categories = "Цеп/булава/молот, двуручное";
		this.m.IconLarge = "xx_weapon_02.png";
		this.m.Icon = "xx_weapon_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_02";
		this.m.Value = 500;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -10;
		this.m.RangeMin = 1;
		this.m.RangeMax = 3;
		this.m.RangeIdeal = 3;
		this.m.RegularDamage = 10;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 0.8;
		this.m.DirectDamageMult = 0.2;
		this.m.ChanceToHitHead = 12;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_meteoraa_skill"));
	}

});

