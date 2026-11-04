this.legend_dilapitated_sling <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_dilapitated_sling";
        this.m.Name = "Ветхая праща";
        this.m.Description = "Простейшая праща для метания камней в противников. Время и использование не прошли для неё даром - вы удивлены, что она до сих пор не развалилась. Камней вокруг в избытке, так что боеприпасы у неё никогда не закончатся.";
		this.m.IconLarge = "weapons/ranged/legend_sling_02.png";
		this.m.Icon = "weapons/ranged/legend_sling_02_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Sling;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_sling_02";
		this.m.Value = 50;
		this.m.StaminaModifier = -3;
		this.m.RangeMin = 2;
		this.m.RangeMax = 6;
		this.m.RangeIdeal = 6;
		this.m.Condition = 20.0;
		this.m.ConditionMax = 20.0;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.4;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 30;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/sling_stone_skill"));
	}

});
