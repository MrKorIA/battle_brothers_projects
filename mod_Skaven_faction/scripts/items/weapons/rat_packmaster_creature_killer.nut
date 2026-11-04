this.rat_packmaster_creature_killer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_packmaster_creature_killer";
		this.m.Name = "Ловушка для тварей скавенов";
		this.m.Description = "Это двуручное древковое оружие имеет большую, похожую на щипцы головку, усаженную внутри шипами. Предназначено для обхвата туловищ и конечностей врагов.";
		this.m.Categories = "Копьё, двуручное";
		this.m.IconLarge = "weapons/melee/rat_packmaster_creature_killer.png";
		this.m.Icon = "weapons/melee/rat_packmaster_creature_killer_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_packmaster_creature_killer";
		this.m.Value = 650;
		this.m.ShieldDamage = 0;
		this.m.Condition = 55.0;
		this.m.ConditionMax = 55.0;
		this.m.StaminaModifier = -12;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local prong = this.new("scripts/skills/actives/prong_skill");
		prong.m.Icon = "skills/rat_spear_active_03.png";
		prong.m.IconDisabled = "skills/rat_spear_active_03_sw.png";
		prong.m.Overlay = "rat_spear_active_03";
		this.addSkill(prong);
		local spearwall = this.new("scripts/skills/actives/spearwall");
		spearwall.m.Icon = "skills/rat_spear_active_04.png";
		spearwall.m.IconDisabled = "skills/rat_spear_active_04_sw.png";
		spearwall.m.Overlay = "rat_spear_active_04";
		spearwall.m.BaseAttackName = prong.getName();
		spearwall.setFatigueCost(spearwall.getFatigueCostRaw() + 5);
		spearwall.m.ActionPointCost = 6;
		this.addSkill(spearwall);
	}

});

