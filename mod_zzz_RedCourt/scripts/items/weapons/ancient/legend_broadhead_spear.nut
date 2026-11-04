this.legend_broadhead_spear <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_broadhead_spear";
		this.m.Name = "Древнее широкое копьё";
        this.m.Description = "Древнее копьё с массивным листовидным наконечником. Оно заметно тяжелее своих собратьев и наносит куда более серьёзные раны, однако уступает им в пробивной силе.";
		this.m.IconLarge = "weapons/melee/legend_broadhead_spear_01.png";
		this.m.Icon = "weapons/melee/legend_broadhead_spear_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Spear;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_broadhead_spear_01";
		this.m.Value = 1050;
		this.m.Condition = 50.0;
		this.m.ConditionMax = 50.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.35;
		this.m.DirectDamageAdd = 0.05;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/thrust"));
		this.addSkill(this.new("scripts/skills/actives/legend_heartseeker_skill"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

});

