this.xxkusarigama <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxkusarigama";
		this.m.Name = "Кусаригама";
		this.m.Description = "Это оружие для самообороны, модифицированное из сельскохозяйственного инструмента. Оно сложно в обращении, но очень мощно в руках профессионалов.";
		this.m.Categories = "тесак/цеп, двуручное";
		this.m.IconLarge = "xx_weapon_17.png";
		this.m.Icon = "xx_weapon_17_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_17";
		this.m.Value = 2000;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -12;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.3;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "При попадании: 15% шанс нанести сильное кровотечение (250 урона на 2 хода, игнорирует иммунитет к кровотечению)"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+30%[/color] к получению опыта"
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local ttt = this.new("scripts/skills/actives/decapitate");
		ttt.m.ID = "actives.cleave";
		ttt.m.IsIgnoredAsAOO = false;
		ttt.m.FatigueCost = 15;
		this.addSkill(ttt);
		ttt = this.new("scripts/skills/actives/lash_skill");
		ttt.m.ID = "actives.flail";
		ttt.m.MaxRange = 2;
		this.addSkill(ttt);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		_properties.XPGainMult *= 1.3;
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
		this.weapon.onDamageDealt(_target, _skill, _hitInfo);
		if (!_target.isAlive() || _target.isDying())
		{
			return;
		}
		if (_skill.getID() == "actives.cleave" || _skill.getID() == "actives.flail")
		{
			if (this.Math.rand(1, 100) <= 15)
			{
				local effect = this.new("scripts/skills/effects/bleeding_effect");
				effect.setDamage(250);
				_target.getSkills().add(effect);
			}
		}
	}

});

