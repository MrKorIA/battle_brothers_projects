this.wushiweapon14 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wushiweapon14";
		this.m.Name = "Юми";
		this.m.Description = "Огромный асимметричный лук, созданный из слоёного бамбука по секретам восточных мастеров. Его уникальная форма требует невероятной силы натяжения, но взамен позволяет посылать тяжёлые стрелы на огромные расстояния, с лёгкостью пробивая кольчужные кольца.";
		this.m.Categories = "Лук, двуручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_14.png";
		this.m.Icon = "weapons/melee/wushi_weapon_14_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_14";
		this.m.Value = 900;
		this.m.RangeMin = 2;
		this.m.RangeMax = 7;
		this.m.RangeIdeal = 7;
		this.m.StaminaModifier = -12;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 0.6;
		this.m.DirectDamageMult = 0.4;
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
		this.addSkill(this.new("scripts/skills/actives/quick_shot"));
		this.addSkill(this.new("scripts/skills/actives/aimed_shot"));
	}

});

