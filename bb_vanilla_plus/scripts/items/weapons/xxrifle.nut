this.xxrifle <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxrifle";
		this.m.Name = "Винтовка Hextech";
		this.m.Description = "Современное оружие дальнего действия, использующее порох. Это оружие является вершиной передовых технологий, и в настоящее время лишь немногие знают, как его изготовить.";
		this.m.Categories = "метательное/арбалет/лук, двуручное";
		this.m.IconLarge = "xx_weapon_18.png";
		this.m.Icon = "xx_weapon_18_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_18";
		this.m.Value = 7000;
		this.m.RangeMin = 1;
		this.m.RangeMax = 7;
		this.m.RangeIdeal = 7;
		this.m.StaminaModifier = -10;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 0.8;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 10;
	}

	function getAmmoID()
	{
		return "ammo.powder";
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Эффект мастерства в метании/арбалете/луке: +1 к дальности, +1 к дальности зрения, +10 к максимальному урону"
		});
		return ret;
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInThrowing)
		{
			_properties.Vision += 1;
			_properties.DamageRegularMax += 10;
		}
		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInCrossbows)
		{
			_properties.Vision += 1;
			_properties.DamageRegularMax += 10;
		}
		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInBows)
		{
			_properties.Vision += 1;
			_properties.DamageRegularMax += 10;
		}
		_properties.TargetAttractionMult *= 1.5;
	}

	function getAdditionalRange( _actor )
	{
		return ((_actor.getCurrentProperties().IsSpecializedInBows ? 1 : 0) + (_actor.getCurrentProperties().IsSpecializedInCrossbows ? 1 : 0) + (_actor.getCurrentProperties().IsSpecializedInThrowing ? 1 : 0));
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_rifleaa_skill"));
	}

});

