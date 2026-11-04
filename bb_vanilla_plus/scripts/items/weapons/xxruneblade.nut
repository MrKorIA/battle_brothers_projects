this.xxruneblade <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxruneblade";
		this.m.Name = "Рунический клинок";
		this.m.Description = "Оружие с клинком, на котором выгравирована руническая магия.";
		this.m.Categories = "тесак/меч, двуручное";
		this.m.IconLarge = "xx_weapon_06.png";
		this.m.Icon = "xx_weapon_06_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_06";
		this.m.Value = 5000;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -10;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.4;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Бонус к максимальному урону: Дальняя защита x 1 (макс.: +100)"
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local ww;
		ww = this.new("scripts/skills/actives/cleave");
		ww.m.FatigueCost = 15;
		ww.m.MaxRange = 2;
		ww.m.ActionPointCost = 6;
		ww.m.DirectDamageMult = 0.4;
		ww.m.SoundOnUse = [
			"sounds/combat/strike_01.wav",
			"sounds/combat/strike_02.wav",
			"sounds/combat/strike_03.wav"
		];
		ww.m.SoundOnHit = [
			"sounds/combat/strike_hit_01.wav",
			"sounds/combat/strike_hit_02.wav",
			"sounds/combat/strike_hit_03.wav"
		];
		this.addSkill(ww);
		ww = this.new("scripts/skills/actives/split");
		ww.m.FatigueCost = 25;
		ww.m.DirectDamageMult = 0.4;
		this.addSkill(ww);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		local gg = this.getContainer().getActor().getBaseProperties().RangedDefense * 1;
		if (gg >= 1)
		{
			_properties.DamageRegularMax += this.Math.min(gg, 100);
		}
	}

});

