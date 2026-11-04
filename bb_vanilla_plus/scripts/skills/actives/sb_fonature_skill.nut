this.sb_fonature_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 2
	},
	function create()
	{
		this.m.ID = "actives.sb_fonature_skill";
		this.m.Name = "Колючая лоза";
		this.m.Description = "Опутывает цель лозами и наносит урон ядом.";
		this.m.Icon = "ui/xx4.png";
		this.m.IconDisabled = "ui/xx4_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/goblin_roots_01.wav",
			"sounds/enemies/goblin_roots_02.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/break_free_roots_00.wav",
			"sounds/combat/break_free_roots_01.wav",
			"sounds/combat/break_free_roots_02.wav",
			"sounds/combat/break_free_roots_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 0;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsDoingForwardMove = false;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.IsUsingHitchance = false;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Можно использовать [color=#8f1e1e]" + this.m.Skillcharge + "[/color] раз(а) в этом бою."
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1

		local effect1 = {
		Delay = 0,
		Quantity = 30,
		LifeTimeQuantity = 30,
		SpawnRate = 700,
		Brushes = [
			"miasma_effect_02",
			"miasma_effect_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 0.75,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 30,
				VelocityMax = 50,
				DirectionMin = this.createVec(-0.5, 0.4),
				DirectionMax = this.createVec(0.5, 0.4),
				SpawnOffsetMin = this.createVec(-30, -30),
				SpawnOffsetMax = this.createVec(30, 0)
			},
			{
				LifeTimeMin = 3.0,
				LifeTimeMax = 4.0,
				ColorMin = this.createColor("9d82172d"),
				ColorMax = this.createColor("f5e6aa2d"),
				ScaleMin = 1.0,
				ScaleMax = 1.0,
				VelocityMin = 30,
				VelocityMax = 50,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 0)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.3,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 1.25,
				ScaleMax = 1.5,
				VelocityMin = 30,
				VelocityMax = 50,
				ForceMin = this.createVec(0, -60),
				ForceMax = this.createVec(0, -60)
			}
		]
		};

		this.Tactical.spawnParticleEffect(false, effect1.Brushes, _targetTile, effect1.Delay, effect1.Quantity * 0.5, effect1.LifeTimeQuantity * 0.5, effect1.SpawnRate, effect1.Stages, this.createVec(0, 40));

		if (!_targetTile.getEntity().getCurrentProperties().IsImmuneToRoot && !_targetTile.getEntity().getCurrentProperties().IsRooted)
		{
			_targetTile.getEntity().getSkills().add(this.new("scripts/skills/effects/rooted_effect"));
			local breakFree = this.new("scripts/skills/actives/break_free_skill");
			breakFree.setDecal("roots_destroyed");
			breakFree.m.Icon = "skills/active_75.png";
			breakFree.m.IconDisabled = "skills/active_75_sw.png";
			breakFree.m.Overlay = "active_75";
			breakFree.m.SoundOnUse = this.m.SoundOnHitHitpoints;
			_targetTile.getEntity().getSkills().add(breakFree);
			_targetTile.getEntity().raiseRootsFromGround("bust_roots", "bust_roots_back");
		}
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, function ( _tag )
		{
			if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable())
			{
				this.attackEntity(_user, _targetTile.getEntity(), false);
			}
		}.bindenv(this), null);
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 20;
			_properties.DamageRegularMax = 50;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.DamageArmorMult *= 0;
			_properties.RangedAttackBlockedChanceMult *= 0;
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
			_properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
		}
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcharge <= 0)
		{
			return false;
		}

		return true;
	}

	function isHidden()
	{
		if (this.m.Skillcharge > 0)
		{
			return false;
		}

		return true;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = 2;
	}

});

