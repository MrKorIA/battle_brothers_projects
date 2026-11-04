this.legend_decorated_rhomphaia <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		Bravery = 5
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_decorated_rhomphaia";
        this.m.Name = "Украшенная ромфея";
        this.m.Description = "Длинный изогнутый клинок с золотыми инкрустациями, на которых запечатлены самые разные сцены - от жатвы до битв. Оружие оказалось куда легче, чем можно предположить по виду, и явно служило церемониальным целям.";
		this.m.IconLarge = "weapons/melee/legend_decorated_rhompaia_01.png";
		this.m.Icon = "weapons/melee/legend_decorated_rhompaia_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Sword;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsDoubleGrippable = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_decorated_rhompaia_01";
		this.m.Value = 1800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 38.0;
		this.m.ConditionMax = 38.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.2;
		this.m.DirectDamageAdd = 0.15;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/split"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
	}
});
