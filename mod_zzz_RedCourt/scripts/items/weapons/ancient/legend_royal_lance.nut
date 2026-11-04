this.legend_royal_lance <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_royal_lance";
        this.m.Name = "Имперский ланец";
        this.m.Description = "Искусно скованное и пережившее века, это копьё способно впечатлить даже современных мастеров. Предназначено для нанесения колющих ударов с расстояния и сдерживания противника на дистанции.";
		this.m.WeaponType = this.Const.Items.WeaponType.Spear;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 1800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 65.0;
		this.m.ConditionMax = 65.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 5;
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/legend_mummy_lance_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/legend_mummy_lance_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_mummy_lance_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/prong_skill");
        skill.m.Icon = "skills/active_54.png";
        skill.m.IconDisabled = "skills/active_54_sw.png";
        skill.m.Overlay = "active_54";
		this.addSkill(skill);
		this.addSkill(this.new("scripts/skills/actives/legend_heartseeker_skill"));
		skill = this.new("scripts/skills/actives/legend_skewer_skill");
        skill.m.Icon = "skills/skewer_spetum.png";
        skill.m.IconDisabled = "skills/skewer_spetum_bw.png";
        skill.m.Overlay = "skewer_spetum";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/spearwall");
        skill.m.Icon = "skills/active_54.png";
        skill.m.IconDisabled = "skills/active_54_sw.png";
        skill.m.Overlay = "active_54";
        skill.m.BaseAttackName = "Prong";
        skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
        skill.m.ActionPointCost = 6;
		this.addSkill(skill);
	}

});
