this.xxheavylance <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxheavylance";
		this.m.Name = "Тяжелая копьё";
		this.m.Description = "Огромное копье в форме конуса. Хорошее оружие для кавалерии в тяжелых доспехах.";
		this.m.Categories = "Оружие, одноручное";
		this.m.IconLarge = "xx_weapon_13.png";
		this.m.Icon = "xx_weapon_13_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_13";
		this.m.Value = 2000;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -15;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.4;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "При езде на \'Коне\' или \'Волке\': Добавляет специальный навык"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда общая прочность брони и шлема составляет 500 или более: +50% к урону от брони"
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_heavylanceaa_skill"));
		this.addSkill(this.new("scripts/skills/actives/xxitem_heavylancebb_skill"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		local actor = this.getContainer().getActor();
		local zzhead = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local xxhead = 0;
		local zzbody = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local xxbody = 0;
		if (zzhead != null)
		{
			xxhead = this.Math.floor(actor.getArmorMax(this.Const.BodyPart.Head) * 1);
		}
		if (zzbody != null)
		{
			xxbody = this.Math.floor(actor.getArmorMax(this.Const.BodyPart.Body) * 1);
		}
		if (xxhead + xxbody >= 500)
		{
			_properties.DamageArmorMult += 0.5;
		}
	}

});

