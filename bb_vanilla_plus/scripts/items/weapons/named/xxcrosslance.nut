this.xxcrosslance <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.xxcrosslance";
		this.m.Description = "Оружие легендарного героя, который в одиночку сражался с тысячей врагов ради народа. Пропитанное душой героя, это оружие обладает мистической силой.";
		this.m.Categories = "Spear/Polearm, Two-Handed";
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
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 10;
		this.m.IconLarge = "xx_weapon_10.png";
		this.m.Icon = "xx_weapon_10_70x70.png";
		this.m.ArmamentIcon = "icon_xx_weapon_10";
		this.m.Name = "Cross Spear";
		this.randomizeValues();
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Копье, мастерство владения копьем: +20 к максимальному урону"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "+10 к защите в ближнем бою, +10 к решимости"
		});
		return ret;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local prong = this.new("scripts/skills/actives/prong_skill");
		this.addSkill(prong);
		local spearwall = this.new("scripts/skills/actives/spearwall");
		spearwall.m.Icon = "skills/active_124.png";
		spearwall.m.IconDisabled = "skills/active_124_sw.png";
		spearwall.m.Overlay = "active_124";
		spearwall.m.BaseAttackName = prong.getName();
		spearwall.setFatigueCost(spearwall.getFatigueCostRaw() + 5);
		spearwall.m.ActionPointCost = 6;
		this.addSkill(spearwall);
		this.addSkill(this.new("scripts/skills/actives/repel"));
		this.addSkill(this.new("scripts/skills/actives/hook"));
		this.addSkill(this.new("scripts/skills/actives/ai_spearwall_fake"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears)
		{
			_properties.DamageRegularMax += 20;
		}
		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInPolearms)
		{
			_properties.DamageRegularMax += 20;
		}
		_properties.MeleeDefense += 10;
		_properties.Bravery += 10;
	}

});

