this.cultist_crowbeak <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.cultist_crowbeak";
		this.m.Name = "Шип культистов";
		this.m.Description = "Тяжёлый шип на длинном древке, используемый для раскалывания брони и сокрушения того, кто находится под ней.";
		this.m.Categories = "Молот, двуручное";
		this.m.IconLarge = "weapons/melee/bill_01.png";
		this.m.Icon = "weapons/melee/bill_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Cultist;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bill_01";
		this.m.Value = 1400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -20;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.85;
		this.m.DirectDamageMult = 0.5;

		this.m.FatigueOnSkillUse = 5;
		this.setArmament()
	}
	function setArmament()
	{
		local prefix;
		local suffix = this.m.Variant
		local full;
		prefix = "cult_weapon_"
		if (suffix == 0 ){
			suffix = this.Math.rand(4, 6)
			this.m.Variant = suffix
		}
		if (suffix < 10) suffix = "0"+ suffix
		full = prefix+suffix
		
		this.m.ArmamentIcon = full
		this.m.Icon = "weapons/melee/" +full+"_icon.png"
		this.m.IconLarge ="weapons/melee/" + full+"_large_icon.png"
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/batter_skill");
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/demolish_armor_skill");
		this.addSkill(skill);
	}

});

