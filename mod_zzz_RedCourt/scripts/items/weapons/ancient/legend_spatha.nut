this.legend_spatha <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_spatha";
        this.m.Name = "Древний имперский меч";
        this.m.Description = "Простой, но смертоносный прямой меч, который центурионы носили с собой, чтобы прорубаться сквозь десятки врагов. Его прочность кроется в массивности клинка, однако пробивной силой против доспехов он не отличается.";
		this.m.IconLarge = "weapons/melee/legend_spatha_01.png";
		this.m.Icon = "weapons/melee/legend_spatha_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Sword;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_spatha_01";
		this.m.Value = 1550;
		this.m.Condition = 62.0;
		this.m.ConditionMax = 62.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.0;
		this.m.DirectDamageMult = 0.2;
		this.m.ShieldDamage = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
		this.addSkill(this.new("scripts/skills/actives/split_shield"));
	}

});

