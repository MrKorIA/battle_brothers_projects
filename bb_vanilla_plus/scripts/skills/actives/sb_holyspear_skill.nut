this.sb_holyspear_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_holyspear_skill";
		this.m.Name = "35. Святое Копье";
		this.m.Description = "Бросает во врага священное копьё, наполненное божественной магической силой. Урон увеличивается, если рядом с заклинателем находится много дружественных персонажей, владеющих этим умением. (Дистанционное умение)";
		this.m.Icon = "ui/xx18.png";
		this.m.IconDisabled = "ui/xx18_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/javelin_throw_01.wav",
			"sounds/combat/javelin_throw_02.wav",
			"sounds/combat/javelin_throw_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/combat/javelin_miss_01.wav",
			"sounds/combat/javelin_miss_02.wav",
			"sounds/combat/javelin_miss_03.wav"
		];
		this.m.SoundOnHitShield = [
			"sounds/combat/split_shield_01.wav",
			"sounds/combat/split_shield_02.wav",
			"sounds/combat/split_shield_03.wav"
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
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningAndPiercingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
		local mmart = "xxprojectile_02";
		local mmid = -1;
		foreach(i, s in this.Const.ProjectileSprite)
		{
			if (s == mmart)
			{
				mmid = i;
				break;
			}
		}
		if (mmid == -1)
		{
			this.Const.ProjectileSprite.push(mmart);
			mmid = this.Const.ProjectileSprite.len() - 1;
			this.Const.ProjectileDecals.push([""]);
		}
		this.m.ProjectileType = mmid;
		this.m.ProjectileTimeScale = 1.5;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of " + this.getMaxRange() + " tiles"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "+20% Additional hit chance, -10% Hit chance per distance tile, Ignores obstacles and only attacks selected target."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Damage increases by +50 for each ally who has this skill within 3 tiles around the caster. (max +200)"
		});
		return ret;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local effect = {
				Delay = 0,
				Quantity = 10,
				LifeTimeQuantity = 10,
				SpawnRate = 150,
				Brushes = [
					"effect_lightning_03"
				],
				Stages = [
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = this.createColor("ffb64fcc"),
						ColorMax = this.createColor("ffb64fff"),
						ScaleMin = 0.25,
						ScaleMax = 0.5,
						RotationMin = -10,
						RotationMax = 10,
						VelocityMin = 60,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, 0.5),
						DirectionMax = this.createVec(0.5, 0.5),
						SpawnOffsetMin = this.createVec(-50, -40),
						SpawnOffsetMax = this.createVec(50, 20),
						ForceMin = this.createVec(0, -50),
						ForceMax = this.createVec(0, -80)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.3,
						ColorMin = this.createColor("ffb64f80"),
						ColorMax = this.createColor("ffb64fff"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						RotationMin = -10,
						RotationMax = 10,
						VelocityMin = 60,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.4, 0.6),
						DirectionMax = this.createVec(0.4, 0.6),
						ForceMin = this.createVec(0, -50),
						ForceMax = this.createVec(0, -80)
					},
					{
						LifeTimeMin = 0.2,
						LifeTimeMax = 0.3,
						ColorMin = this.createColor("ffb64fcc"),
						ColorMax = this.createColor("ffb64fff"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						RotationMin = -10,
						RotationMax = 10,
						VelocityMin = 60,
						VelocityMax = 100,
						ForceMin = this.createVec(0, -50),
						ForceMax = this.createVec(0, -80)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetEntity.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
		}
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
		local target = _targetTile.getEntity();
		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}
			if (myTile.getDistanceTo(a.getTile()) > 3)
			{
				continue;
			}
			if (!a.getSkills().hasSkill("actives.sb_holyspear_skill"))
			{
				continue;
			}
			if (a.getFaction() == _user.getFaction())
			{
				local flip = !this.m.IsProjectileRotated && target.getPos().X > a.getPos().X;
				this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], a.getTile(), _targetTile, 0.8 + (this.Math.rand(1, 3) * 0.1), this.m.ProjectileTimeScale - (this.Math.rand(3, 5) * 0.1), this.m.IsProjectileRotated, flip);
			}
		}
		return this.attackEntity(_user, target, false);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
			_properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
			_properties.DamageDirectAdd = 0;
			_properties.DamageDirectMeleeAdd = 0;
			_properties.DamageDirectRangedAdd = 0;
			_properties.DamageDirectMult = 1;
			local actor = this.getContainer().getActor();
			local rr = 0;
			if (actor.isPlacedOnMap())
			{
				local myTile = actor.getTile();
				local actors = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
				foreach( a in actors )
				{
					if (a.getID() == actor.getID())
					{
						continue;
					}
					if (myTile.getDistanceTo(a.getTile()) > 3)
					{
						continue;
					}
					if (!a.getSkills().hasSkill("actives.sb_holyspear_skill"))
					{
						continue;
					}
					if (a.getFaction() == actor.getFaction())
					{
						rr = rr + 50;
					}
				}
			}
			_properties.DamageRegularMin = this.Math.min(50 + rr, 250);
			_properties.DamageRegularMax = this.Math.min(70 + rr, 270);
			_properties.DamageArmorMult = 1;
			_properties.RangedSkill += 20;
			_properties.HitChanceAdditionalWithEachTile += -10;
			_properties.RangedAttackBlockedChanceMult *= 0;
		}
	}

});

