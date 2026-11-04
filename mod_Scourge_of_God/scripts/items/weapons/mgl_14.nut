this.mgl_14 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.mgl_14";
		this.m.Name = "Степной лук";
		this.m.Description = "Длинный лук с огромной силой натяжения. Специально разработан для боя.";
		this.m.Categories = "Лук, двуручный";
		this.m.IconLarge = "weapons/ranged/bow_05.png";
		this.m.Icon = "weapons/ranged/bow_05_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "mgl_14";
		this.m.Value = 1900;
		this.m.RangeMin = 2;
		this.m.RangeMax = 8;
		this.m.RangeIdeal = 8;
		this.m.StaminaModifier = -12;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.35;
	}

	function getAmmoID()
	{
		return "ammo.arrows";
	}

	function getAdditionalRange( _actor )
	{
		return _actor.getCurrentProperties().IsSpecializedInBows ? 1 : 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/mgl_13_02"));
		this.addSkill(this.new("scripts/skills/actives/mgl_13_01"));
	}

});

