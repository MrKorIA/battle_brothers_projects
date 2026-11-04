this.ai_punch_basilisk <- this.inherit("scripts/skills/skill", {
	m = {	},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Basilisk Attack";
		this.m.SoundOnHit = [
			"sounds/combat/bash_hit_01.wav",
			"sounds/combat/bash_hit_02.wav",
			"sounds/combat/bash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 100;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileTimeScale = 1.8;
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);
			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
		}
		local left = dir - 1 < 0 ? 5 : dir - 1;
		if (_targetTile.hasNextTile(left))
		{
			local forwardTile = _targetTile.getNextTile(left);
			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
		}
		local right = dir + 1 > 5 ? 0 : dir + 1;
		if (_targetTile.hasNextTile(right))
		{
			local forwardTile = _targetTile.getNextTile(right);
			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
		}
		return ret;
	}

	function BasiliskEffect()
	{
		return [
			{
				Delay = 0,
				Quantity = 30,
				LifeTimeQuantity = 10,
				SpawnRate = 30,
				Brushes = [
					"miasma_effect_02",
					"miasma_effect_03"
				],
				Stages = [
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("74961700"),
						ColorMax = this.createColor("e1f5aa00"),
						ScaleMin = 0.25,
						ScaleMax = 0.5,
						RotationMin = 0,
						RotationMax = 359,
						TorqueMin = -10,
						TorqueMax = 10,
						VelocityMin = 50,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.25, -0.5),
						DirectionMax = this.createVec(0.25, -1.0),
						SpawnOffsetMin = this.createVec(-30, 100),
						SpawnOffsetMax = this.createVec(30, 150),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					},
					{
						LifeTimeMin = 0.8,
						LifeTimeMax = 1.2,
						ColorMin = this.createColor("7496172d"),
						ColorMax = this.createColor("e1f5aa2d"),
						ScaleMin = 0.5,
						ScaleMax = 1.0,
						VelocityMin = 50,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.25, -0.5),
						DirectionMax = this.createVec(0.25, -1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					},
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("74961700"),
						ColorMax = this.createColor("e1f5aa00"),
						ScaleMin = 0.5,
						ScaleMax = 1.0,
						VelocityMin = 50,
						VelocityMax = 100,
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					}
				]
			},
			{
				Delay = 0,
				Quantity = 30,
				LifeTimeQuantity = 10,
				SpawnRate = 30,
				Brushes = [
					"effect_fire_01",
					"effect_fire_02",
					"effect_fire_03"
				],
				Stages = [
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("74961700"),
						ColorMax = this.createColor("e1f5aa00"),
						ScaleMin = 0.75,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 359,
						TorqueMin = -10,
						TorqueMax = 10,
						VelocityMin = 50,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.25, 0.5),
						DirectionMax = this.createVec(0.25, 1.0),
						SpawnOffsetMin = this.createVec(-30, -100),
						SpawnOffsetMax = this.createVec(30, 50),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					},
					{
						LifeTimeMin = 0.8,
						LifeTimeMax = 1.2,
						ColorMin = this.createColor("7496174f"),
						ColorMax = this.createColor("e1f5aa4f"),
						ScaleMin = 1.0,
						ScaleMax = 1.25,
						VelocityMin = 50,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.25, 0.5),
						DirectionMax = this.createVec(0.25, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					},
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("74961700"),
						ColorMax = this.createColor("e1f5aa00"),
						ScaleMin = 1.0,
						ScaleMax = 1.25,
						VelocityMin = 50,
						VelocityMax = 100,
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					}
				]
			},
			{
				Delay = 0,
				Quantity = 30,
				LifeTimeQuantity = 10,
				SpawnRate = 30,
				Brushes = [
					"effect_fire_01",
					"effect_fire_02",
					"effect_fire_03"
				],
				Stages = [
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("74961700"),
						ColorMax = this.createColor("e1f5aa00"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						RotationMin = 0,
						RotationMax = 359,
						TorqueMin = -10,
						TorqueMax = 10,
						VelocityMin = 50,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, -0.2),
						DirectionMax = this.createVec(-1.0, 0.2),
						SpawnOffsetMin = this.createVec(50, 0),
						SpawnOffsetMax = this.createVec(100, 75),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.8,
						LifeTimeMax = 1.2,
						ColorMin = this.createColor("7496174f"),
						ColorMax = this.createColor("e1f5aa4f"),
						ScaleMin = 0.75,
						ScaleMax = 1.0,
						VelocityMin = 50,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, -0.25),
						DirectionMax = this.createVec(-1.0, 0.25),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("74961700"),
						ColorMax = this.createColor("e1f5aa00"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						VelocityMin = 50,
						VelocityMax = 100,
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					}
				]
			},
			{
				Delay = 0,
				Quantity = 20,
				LifeTimeQuantity = 5,
				SpawnRate = 10,
				Brushes = [
					"miasma_effect_02",
					"miasma_effect_03"
				],
				Stages = [
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("9d821700"),
						ColorMax = this.createColor("f5e6aa00"),
						ScaleMin = 0.25,
						ScaleMax = 0.5,
						RotationMin = 0,
						RotationMax = 359,
						TorqueMin = -10,
						TorqueMax = 10,
						VelocityMin = 10,
						VelocityMax = 30,
						DirectionMin = this.createVec(-0.5, 0.5),
						DirectionMax = this.createVec(0.5, 0.5),
						SpawnOffsetMin = this.createVec(-50, -40),
						SpawnOffsetMax = this.createVec(50, 20),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					},
					{
						LifeTimeMin = 0.8,
						LifeTimeMax = 1.2,
						ColorMin = this.createColor("9d82172d"),
						ColorMax = this.createColor("f5e6aa2d"),
						ScaleMin = 0.5,
						ScaleMax = 1.0,
						VelocityMin = 10,
						VelocityMax = 30,
						DirectionMin = this.createVec(-0.4, 0.6),
						DirectionMax = this.createVec(0.4, 0.6),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					},
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("9d821700"),
						ColorMax = this.createColor("f5e6aa00"),
						ScaleMin = 0.5,
						ScaleMax = 1.0,
						VelocityMin = 10,
						VelocityMax = 30,
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					}
				]
			},
			{
				Delay = 0,
				Quantity = 10,
				LifeTimeQuantity = 10,
				SpawnRate = 2,
				Brushes = [
					"effect_fire_01",
					"effect_fire_02",
					"effect_fire_03"
				],
				Stages = [
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("9d821700"),
						ColorMax = this.createColor("f5e6aa00"),
						ScaleMin = 0.75,
						ScaleMax = 1.0,
						VelocityMin = 10,
						VelocityMax = 30,
						DirectionMin = this.createVec(-0.5, 0.5),
						DirectionMax = this.createVec(0.5, 0.5),
						SpawnOffsetMin = this.createVec(-50, -40),
						SpawnOffsetMax = this.createVec(50, 10),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					},
					{
						LifeTimeMin = 0.8,
						LifeTimeMax = 1.2,
						ColorMin = this.createColor("9d82174f"),
						ColorMax = this.createColor("f5e6aa4f"),
						ScaleMin = 1.0,
						ScaleMax = 1.25,
						VelocityMin = 10,
						VelocityMax = 30,
						DirectionMin = this.createVec(-0.4, 0.6),
						DirectionMax = this.createVec(0.4, 0.6),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					},
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("9d821700"),
						ColorMax = this.createColor("f5e6aa00"),
						ScaleMin = 1.0,
						ScaleMax = 1.25,
						VelocityMin = 10,
						VelocityMax = 30,
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 10)
					}
				]
			},
			{
				Delay = 200,
				Quantity = 20,
				LifeTimeQuantity = 50,
				SpawnRate = 5,
				Brushes = [
					"dust_01",
					"dust_02"
				],
				Stages = [
					{
						LifeTimeMin = 0.8,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("ffffff3f"),
						ColorMax = this.createColor("ffffff3f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						SpawnOffsetMin = this.createVec(-10, -10),
						SpawnOffsetMax = this.createVec(10, 10),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.8,
						LifeTimeMax = 0.8,
						ColorMin = this.createColor("ffffff1f"),
						ColorMax = this.createColor("ffffff1f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = this.createColor("ffffff00"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					}
				]
			}
		];
	}

	function onUse( _user, _targetTile )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID())
		{
			if (_user.getTile().getDistanceTo(_targetTile) == 1)
			{
				this.m.Name = "Bite";
				this.m.IsRanged = false;
				this.m.DirectDamageMult = 0.5;
				this.spawnIcon("active_107", _user.getTile());
				this.Sound.play("sounds/enemies/lindwurm_gorge_01.wav", this.Const.Sound.Volume.Skill * 1.0, _targetTile.Pos);
				_user.getCurrentProperties().DamageTotalMult += 1;
				return this.attackEntity(_user, _targetTile.getEntity());
			}
			else
			{
				this.m.Name = "Breath";
				this.m.IsRanged = true;
				this.m.DirectDamageMult = 0.3;
				local tag = {
					Skill = this,
					User = _user,
					TargetTile = _targetTile
				};
				local fx = this.BasiliskEffect();
				for( local i = 0; i < fx.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, fx[i].Brushes, _user.getTile(), fx[i].Delay, fx[i].Quantity, fx[i].LifeTimeQuantity, fx[i].SpawnRate, fx[i].Stages);
				}
				this.Sound.play("sounds/enemies/vampire_takeoff_01.wav", this.Const.Sound.Volume.Skill * 1.0, _targetTile.Pos);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
			}
		}
		else
		{
			this.m.Name = "Bite";
			this.m.IsRanged = false;
			this.m.DirectDamageMult = 0.5;
			this.spawnIcon("active_107", _user.getTile());
			this.Sound.play("sounds/enemies/lindwurm_gorge_01.wav", this.Const.Sound.Volume.Skill * 1.0, _targetTile.Pos);
			_user.getCurrentProperties().DamageTotalMult += 1;
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local targetTile = _tag.TargetTile;
		local myTile = user.getTile();
		local dir = myTile.getDirectionTo(targetTile);
		local targets = this.getAffectedTiles(targetTile);
		this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 1.2, user.getPos());
		foreach( t in targets )
		{
			local fx = this.BasiliskEffect();
			for( local i = 0; i < fx.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, fx[i].Brushes, t, fx[i].Delay, fx[i].Quantity, fx[i].LifeTimeQuantity, fx[i].SpawnRate, fx[i].Stages);
			}

			local flip = t.Pos.X > user.getPos().X;
			this.Tactical.spawnProjectileEffect("blood_splatter_green_0" + this.Math.rand(1, 2), myTile, t, 1.4, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 75, function ( _skill )
			{
				this.Tactical.spawnProjectileEffect("blood_splatter_green_0" + this.Math.rand(1, 2), myTile, t, 1.4 / 2 + 0.1, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}.bindenv(this), this);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 150, function ( _skill )
			{
				this.Tactical.spawnProjectileEffect("blood_splatter_green_0" + this.Math.rand(1, 2), myTile, t, 0.3 + (this.Math.rand(0, 2) * 0.1), this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}.bindenv(this), this);

			if (t.IsOccupiedByActor && t.getEntity().isAttackable())
			{
				local e = t.getEntity();
				if (!e.isAlliedWith(_tag.User))
				{
					this.attackEntity(_tag.User, e, false);
				}
			}
		}
		_tag.Skill.m.IsRanged = false;
		return true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			if (this.Math.rand(1, 5) == 3)
			{
				if (!_targetEntity.getCurrentProperties().IsImmuneToDaze)
				{
					_targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 40;
			_properties.DamageRegularMax = 75;
			_properties.DamageArmorMult = 0.9;
		}
	}

});

