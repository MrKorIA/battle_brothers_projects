this.sb_acidbomb_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 9,
		Skillcool = 9,
		SoundOnPoison = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		]
	},
	function create()
	{
		this.m.ID = "actives.sb_acidbomb_skill";
		this.m.Name = "2. Кислотная граната";
		this.m.Description = "Бросает кислотную гранату в указанную область, разъедая броню и шлем. \n[color=#8f1e1e]Требования:[/color] 199 Корон";
		this.m.Icon = "ui/xx13.png";
		this.m.IconDisabled = "ui/xx13_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/throw_ball_01.wav",
			"sounds/combat/throw_ball_02.wav",
			"sounds/combat/throw_ball_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/acid_flask_impact_01.wav",
			"sounds/combat/acid_flask_impact_02.wav",
			"sounds/combat/acid_flask_impact_03.wav",
			"sounds/combat/acid_flask_impact_04.wav"
		];
		this.m.SoundVolume = 1.1;
		this.m.SoundOnHitDelay = 300;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 300;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 3;
		this.m.ProjectileType = this.Const.ProjectileType.Flask;
		this.m.ProjectileTimeScale = 1.5;
		this.m.IsProjectileRotated = false;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of " + this.getMaxRange() + " tiles"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Damage: [color=" + this.Const.UI.Color.PositiveValue + "]30~90[/color]"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cooldown : 9 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
		});
		if (this.Tactical.isActive())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/asset_money.png",
				text = "Own [color=#e6b71e]" + this.World.Assets.getMoney() + "[/color] crowns"
			});
		}
		return ret;
	}

	function addResources()
	{
		foreach( r in this.m.SoundOnPoison )
		{
			this.Tactical.addResource(r);
		}
	}

	function onTargetSelected( _targetTile )
	{
		local affectedTiles = [];
		affectedTiles.push(_targetTile);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				affectedTiles.push(tile);
			}
		}

		foreach( t in affectedTiles )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_originTile.Level + 1 < _targetTile.Level)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		this.World.Assets.addMoney(-199);
		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		{
			local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
			if (_user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
			{
				this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}
		this.Time.scheduleEvent(this.TimeUnit.Real, 250, this.onApply.bindenv(this), {
			Skill = this,
			TargetTile = _targetTile
		});
		return true;
	}

	function onApply( _data )
	{
		local effect = {
			Delay = 0,
			Quantity = 200,
			LifeTimeQuantity = 10,
			SpawnRate = 150,
			Brushes = [
				"blood_splatter_green_01",
				"blood_splatter_green_02",
				"blood_splatter_green_05",
				"blood_splatter_green_06",
				"blood_splatter_green_07",
				"blood_splatter_green_08",
				"blood_splatter_green_09"
			],
			Stages = [
				{
					LifeTimeMin = 0.3,
					LifeTimeMax = 0.5,
					ColorMin = this.createColor("ffffff00"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 1.3,
					ScaleMax = 1.5,
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
					LifeTimeMin = 0.3,
					LifeTimeMax = 0.5,
					ColorMin = this.createColor("ffffffff"),
					ColorMax = this.createColor("ffffffff"),
					ScaleMin = 1.3,
					ScaleMax = 1.5,
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
					LifeTimeMin = 0.3,
					LifeTimeMax = 0.3,
					ColorMin = this.createColor("ffffff00"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.5,
					ScaleMax = 0.7,
					RotationMin = 0,
					RotationMax = 359,
					TorqueMin = 10,
					TorqueMax = 20,
					VelocityMin = 100,
					VelocityMax = 150,
					DirectionMin = this.createVec(-0.2, 0.6),
					DirectionMax = this.createVec(0.2, 0.6),
					SpawnOffsetMin = this.createVec(0, 0),
					SpawnOffsetMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.3,
					ColorMin = this.createColor("ffffffff"),
					ColorMax = this.createColor("ffffffff"),
					ScaleMin = 0.3,
					ScaleMax = 0.5,
					VelocityMin = 150,
					VelocityMax = 150,
					ForceMin = this.createVec(-30, 0),
					ForceMax = this.createVec(-10, 0)
				},
				{
					LifeTimeMin = 0.3,
					LifeTimeMax = 0.5,
					ColorMin = this.createColor("ffffff7f"),
					ColorMax = this.createColor("ffffff7f"),
					ScaleMin = 0.05,
					ScaleMax = 0.2,
					VelocityMin = 0,
					VelocityMax = 0,
					ForceMin = this.createVec(0, -180),
					ForceMax = this.createVec(0, -180)
				}
			]
		};
		local targets = [];
		targets.push(_data.TargetTile);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_data.TargetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _data.TargetTile.getNextTile(i);
				targets.push(tile);
			}
		}

		if (_data.Skill.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(_data.Skill.m.SoundOnHit[this.Math.rand(0, _data.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.4, _data.TargetTile.Pos);
		}
		if (this.m.SoundOnPoison.len() != 0)
		{
			this.Sound.play(this.m.SoundOnPoison[this.Math.rand(0, this.m.SoundOnPoison.len() - 1)], this.Const.Sound.Volume.Skill * 1.4, _data.TargetTile.Pos);
		}

		foreach( tile in targets )
		{
			this.Tactical.spawnParticleEffect(false, effect.Brushes, tile, effect.Delay, effect.Quantity * 0.5, effect.LifeTimeQuantity * 0.5, effect.SpawnRate, effect.Stages, this.createVec(0, 40));

			if (tile.IsOccupiedByActor)
			{
				onApplyMagicDamage(tile, tile.getEntity());
			}
		}
	}

	function onApplyMagicDamage( _tile, _entity )
	{
		this.Tactical.spawnIconEffect("status_effect_78", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
		for( local i = 0; i < this.Const.Tactical.AcidParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.AcidParticles[i].Brushes, _tile, this.Const.Tactical.AcidParticles[i].Delay, this.Const.Tactical.AcidParticles[i].Quantity, this.Const.Tactical.AcidParticles[i].LifeTimeQuantity, this.Const.Tactical.AcidParticles[i].SpawnRate, this.Const.Tactical.AcidParticles[i].Stages);
		}
		local damage = this.Math.rand(30, 90);
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = 0;
		hitInfo.DamageArmor = damage;
		hitInfo.DamageDirect = 0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1;
		hitInfo.FatalityChanceMult = 0;
		_entity.onDamageReceived(_entity, null, hitInfo);
		hitInfo.BodyPart = this.Const.BodyPart.Head;
		_entity.onDamageReceived(_entity, null, hitInfo);
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		if (this.World.Assets.getMoney() < 199)
		{
			return false;
		}
		if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}
		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

