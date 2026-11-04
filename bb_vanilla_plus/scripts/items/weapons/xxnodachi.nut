this.xxnodachi <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxnodachi";
		this.m.Name = "Нодачи";
		this.m.Description = "Это экзотический двуручный меч с очень длинным клинком. Только опытные воины могут правильно им пользоваться.";
		this.m.Categories = "Меч, двуручный";
		this.m.IconLarge = "xx_weapon_07.png";
		this.m.Icon = "xx_weapon_07_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = false;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_07";
		this.m.Value = 5000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -15;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.8;
		this.m.DirectDamageMult = 0.2;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+2.5[/color] Урон за уровень (макс : +70)"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] Ближняя, Дальняя защита"
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local gash = this.new("scripts/skills/actives/gash_skill");
		gash.m.ID = "actives.slash";
		gash.m.IsIgnoredAsAOO = false;
		gash.m.FatigueCost = 15;
		this.addSkill(gash);
		local riposte = this.new("scripts/skills/actives/riposte");
		riposte.m.FatigueCost = 25;
		this.addSkill(riposte);
		this.addSkill(this.new("scripts/skills/actives/swing"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		local actor = this.getContainer().getActor();
		local rr = this.Math.min(actor.getLevel() * 2.5, 70);
		_properties.DamageRegularMin += rr;
		_properties.DamageRegularMax += rr;
		_properties.MeleeDefenseMult *= 0.5;
		_properties.RangedDefenseMult *= 0.5;
	}

});

