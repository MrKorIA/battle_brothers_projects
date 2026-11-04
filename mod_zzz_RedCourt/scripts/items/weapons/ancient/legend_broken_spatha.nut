this.legend_broken_spatha <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_broken_spatha";
		this.m.Name = "Сломанный древний имперский меч";
        this.m.Description = "Тяжёлый меч, переломившийся, несмотря на свою прочность. Повреждение лишь преобразило клинок, превратив его в орудие смерти иного рода.";
		this.m.IconLarge = "weapons/melee/legend_broken_spatha_01.png";
		this.m.Icon = "weapons/melee/legend_broken_spatha_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Dagger;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_broken_spatha";
		this.m.Value = 800;
		this.m.Condition = 42.0;
		this.m.ConditionMax = 42.0;
		this.m.StaminaModifier = -5;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local s = this.new("scripts/skills/actives/stab");
		s.m.Icon = "skills/active_198.png";
		s.m.IconDisabled = "skills/active_198_sw.png";
		s.m.Overlay = "active_198";
		this.addSkill(s);
		this.addSkill(this.new("scripts/skills/actives/deathblow_skill"));
	}

});

