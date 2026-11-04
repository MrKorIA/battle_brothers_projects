this.xxringblade <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxringblade";
		this.m.Name = "Лезвие кольца";
		this.m.Description = "Древнее оружие с кольцеобразным лезвием. Оно обладает таинственной способностью возвращаться к тому, кто его бросил, что делает его более смертоносным оружием в руках воина, обученного как ближнему, так и дальнему бою.";
		this.m.Categories = "оружие, одноручное";
		this.m.IconLarge = "xx_weapon_05.png";
		this.m.Icon = "xx_weapon_05_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_05";
		this.m.Value = 5000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -10;
		this.m.RangeMin = 1;
		this.m.RangeMax = 3;
		this.m.RangeIdeal = 3;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_ringbladeaa_skill"));
		this.addSkill(this.new("scripts/skills/actives/xxitem_ringbladebb_skill"));
	}

});

