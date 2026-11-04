this.cultist_mancatcher <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.cultist_mancatcher";
		this.m.Name = "Людолов культистов";
		this.m.Description = "Диковинное оружие, используемое для удержания врагов на месте.";
		this.m.Categories = "Древковое, двуручное";
		this.m.IconLarge = "weapons/melee/cult_mancatcher_large_icon.png";
		this.m.Icon = "weapons/melee/cult_mancatcher_icon.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Cultist;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "cult_mancatcher";
		this.m.Value = 1400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.3;
		this.m.DirectDamageMult = 0.3;
		this.m.FatigueOnSkillUse = 3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_mancatcher_skill");
		strike.m.Icon = "skills/active_93.png";
		strike.m.IconDisabled = "skills/active_93_sw.png";
		strike.m.Overlay = "active_93";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/catch_enemy_skill"));
		this.addSkill(this.new("scripts/skills/actives/rattle_skill"));
	}

	function onPutIntoBag()
	{
		this.getContainer().getActor().getSkills().removeByID("effects.catching_enemy")
	}

});

