this.xxshuriken <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.m.Ammo + "/" + this.m.AmmoMax;
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxshuriken";
		this.m.Name = "Сюрикен";
		this.m.Description = "Сюрикен — метательное оружие, используемое воинами Востока. Урон по броне слабый, но оно очень легкое и может быть брошено несколько раз.";
		this.m.Categories = "метательное/кинжал, одноручное";
		this.m.IconLarge = "xx_weapon_12.png";
		this.m.Icon = "xx_weapon_12_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_12";
		this.m.Value = 300;
		this.m.Ammo = 10;
		this.m.AmmoMax = 10;
		this.m.RangeMin = 2;
		this.m.RangeMax = 5;
		this.m.RangeIdeal = 5;
		this.m.StaminaModifier = 0;
		this.m.RegularDamage = 5;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.5;
		this.m.DirectDamageMult = 0.2;
		this.m.ShieldDamage = 0;
		this.m.ChanceToHitHead = 5;
		this.m.IsDroppedAsLoot = true;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда левая рука пуста: При ударе наносит, \'Подавляющий\' дебафф на цели."
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_shurikenaa_skill"));
	}

	function setAmmo( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
		this.weapon.onDamageDealt(_target, _skill, _hitInfo);
		if (!_target.isAlive() || _target.isDying())
		{
			return;
		}
		if (_skill.getID() == "actives.xx_a")
		{
			local offh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			if (offh == null)
			{
				_target.getSkills().add(this.new("scripts/skills/effects/overwhelmed_effect"));
			}
		}
	}

});

