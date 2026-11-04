this.xxscythe <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.xxscythe";
		this.m.Description = "Это волшебное оружие древних, известное тем, что оно пожирает жизнь.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3500;
		this.m.ShieldDamage = 0;
		this.m.Condition = 90;
		this.m.ConditionMax = 90;
		this.m.StaminaModifier = -15;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 10;
		this.m.IconLarge = "xx_weapon_11.png";
		this.m.Icon = "xx_weapon_11_70x70.png";
		this.m.ArmamentIcon = "icon_xx_weapon_11";
		this.m.Name = "Death\'s Scythe";
		this.randomizeValues();
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
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
		this.addSkill(this.new("scripts/skills/actives/xxitem_scytheaa_skill"));
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "When killing enemy: -10 fatigue, +20 healing HP, +20 repair armor"
		});
		return ret;
	}

});

