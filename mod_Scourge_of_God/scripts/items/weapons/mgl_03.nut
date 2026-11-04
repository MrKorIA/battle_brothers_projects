this.mgl_03 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.mgl_03";
		this.m.Name = "Хулд-Илд";
		this.m.Description = "Грозный и невероятно тяжёлый боевой тесак на длинном древке, украшенный литой позолоченной муфтой. Позволяющий наносить мощные рубящие удары на расстоянии.";
		this.m.Categories = "Древковое, двуручное";
		this.m.IconLarge = "weapons/melee/mgl_03.png";
		this.m.Icon = "weapons/melee/mgl_03_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "mgl_03";
		this.m.Value = 1300;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -18;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/active_200.png";
		strike.m.IconDisabled = "skills/active_200_sw.png";
		strike.m.Overlay = "active_200";
		this.addSkill(strike);
		local reap = this.new("scripts/skills/actives/reap_skill");
		reap.m.Icon = "skills/active_201.png";
		reap.m.IconDisabled = "skills/active_201_sw.png";
		reap.m.Overlay = "active_201";
		this.addSkill(reap);
	}

});

