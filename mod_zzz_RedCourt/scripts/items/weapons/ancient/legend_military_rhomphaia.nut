this.legend_military_rhomphaia <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_military_rhomphaia";
        this.m.Name = "Украшенная ромфея";
        this.m.Description = "Более прямая и тяжёлая, чем обычные ромфеи, - похоже, этот экземпляр специально сконструирован и доработан для дуэльных поединков. Оружие лишено рубящей кромки, но, несмотря на свой вес, заметно удобнее в обращении.";
		this.m.IconLarge = "weapons/melee/legend_military_rhompaia_01.png";
		this.m.Icon = "weapons/melee/legend_military_rhompaia_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Sword;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsDoubleGrippable = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_military_rhompaia_01";
		this.m.Value = 2000;
		this.m.ShieldDamage = 5;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.2;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/split"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}
});