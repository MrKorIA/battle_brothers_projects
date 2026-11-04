this.legend_broken_decorated_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		Bravery = 5
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_broken_decorated_sword";
		this.m.Name = "Сломанный древний украшенный меч";
        this.m.Description = "Сломанный церемониальный меч, у которого, помимо места излома, почти не осталось острых кромок. Тем не менее, в руках умелого бойца он всё ещё представляет собой смертоносное оружие.";
		this.m.IconLarge = "weapons/melee/legend_broken_decorated_sword_01.png";
		this.m.Icon = "weapons/melee/legend_broken_decorated_sword_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Dagger;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_broken_decorated_sword_01";
		this.m.Value = 400;
		this.m.Condition = 32.0;
		this.m.ConditionMax = 32.0;
		this.m.StaminaModifier = -2;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.4;
		this.m.DirectDamageMult = 0.2;
		this.m.DirectDamageAdd = 0.1;
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

