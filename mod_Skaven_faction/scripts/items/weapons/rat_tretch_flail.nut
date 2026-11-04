this.rat_tretch_flail <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		LastSkillUse = 0
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_tretch_flail";
		this.m.Name = "Трёхглавый цеп скавенов";
		this.m.Description = "Три отдельных бойка, прикреплённых к рукояти цепями. Каждый боёк может попасть или промахнуться по цели отдельно и ударить поверх или вокруг укрытия щитом.";
		this.m.Categories = "Цеп, одноручный";
		this.m.IconLarge = "weapons/melee/rat_tretch_flail.png";
		this.m.Icon = "weapons/melee/rat_tretch_flail_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.ItemProperty = this.Const.Items.Property.IgnoresShieldwall;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rat_flail_three_headed";
		this.m.Value = 1500;
		this.m.ShieldDamage = 0;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local cascade = this.new("scripts/skills/actives/cascade_skill");
		cascade.m.Icon = "skills/rat_flail_active_01.png";
		cascade.m.IconDisabled = "skills/rat_flail_active_01_sw.png";
		cascade.m.Overlay = "rat_flail_active_01";
		this.addSkill(cascade);
		local hail = this.new("scripts/skills/actives/hail_skill");
		hail.m.Icon = "skills/rat_flail_active_02.png";
		hail.m.IconDisabled = "skills/rat_flail_active_02_sw.png";
		hail.m.Overlay = "rat_flail_active_02";
		this.addSkill(hail);

	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
		local actor = this.getContainer().getActor();

		if (actor == null || actor.isNull() || this.m.LastSkillUse == this.Const.SkillCounter)
		{
			return;
		}

		if (actor.isPlayerControlled() && _skill.getDirectDamage() < 1.0 && !_skill.isRanged() && this.m.ConditionMax > 1)
		{
			this.m.LastSkillUse = this.Const.SkillCounter;

			if (_target.getArmorMax(_hitInfo.BodyPart) >= 50 && _hitInfo.DamageInflictedArmor >= 5 || this.m.ConditionMax == 2)
			{
				this.lowerCondition();
			}
		}
	}

});

