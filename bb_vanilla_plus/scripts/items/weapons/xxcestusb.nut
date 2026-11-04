this.xxcestusb <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxcestusb";
		this.m.Name = "Цестус";
		this.m.Description = "Боевые перчатки, предназначенные для защиты рук владельца.";
		this.m.Categories = "Оружие, двуручное";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.IconLarge = "xx_weapon_21_70x70.png";
		this.m.Icon = "xx_weapon_21.png";
		this.m.ArmamentIcon = "icon_xx_weapon_21";
		this.m.Value = 150;
		this.m.Condition = 50.0;
		this.m.ConditionMax = 50.0;
		this.m.StaminaModifier = 0;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 0.5;
		this.m.DirectDamageMult = 0.1;
		this.m.ChanceToHitHead = 10;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Даёт бонус за каждый [color=" + this.Const.UI.Color.PositiveValue + "]Уровень[/color] персонажа к попаданию в голову"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Инициативе \n[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к Защите в ближнем бою \n(Если не освоен навык \'Быстрые руки\'.)"
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_cestusaa_skill"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += this.getContainer().getActor().getLevel() * 1;
		if (!this.getContainer().getActor().getSkills().hasSkill("perk.quick_hands"))
		{
			_properties.Initiative += 20;
			_properties.MeleeDefense += 10;
		}
	}

});

