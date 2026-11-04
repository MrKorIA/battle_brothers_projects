this.xxarcanespear <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxarcanespear";
		this.m.Name = "Жезл магии";
		this.m.Description = "Дальнобойное оружие массового уничтожения, которое легко разрушает броню. Оно имеет очень низкую прочность и быстро изнашивается.";
		this.m.Categories = "Оружие, двуручное";
		this.m.IconLarge = "xx_weapon_15.png";
		this.m.Icon = "xx_weapon_15_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_15";
		this.m.Value = 12000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.StaminaModifier = -15;
		this.m.RangeMin = 2;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.RegularDamage = 10;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 2.4;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_arcanespearaa_skill"));
	}

	function onUse( _skill )
	{
		if (this.getContainer().getActor().isPlayerControlled() && _skill.getID() == "actives.aoe_a" && this.m.ConditionMax > 1)
		{
			this.lowerCondition(3);
		}
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
	}

});

