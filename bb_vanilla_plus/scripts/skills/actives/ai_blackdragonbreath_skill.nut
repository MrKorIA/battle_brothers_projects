this.ai_blackdragonbreath_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.aoe_a";
		this.m.Name = "Ядовитое дыхание";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_takeoff_01.wav",
			"sounds/enemies/vampire_takeoff_02.wav",
			"sounds/enemies/vampire_takeoff_03.wav"
		];
		this.m.SoundVolume = 1.3;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 222;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = false;
		this.m.IsTargetingActor = false;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 10;
		this.m.MinRange = 4;
		this.m.MaxRange = 20;
		this.m.MaxLevelDifference = 4;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onTargetSelected( _targetTile )
	{
		local tiles = this.getAffectedTiles(_targetTile);
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);

		if (tiles.len() != 0)
		{
			foreach( t in tiles )
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
			}
		}
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local ownTile = this.m.Container.getActor().getTile();
		for( local i = 0; i != 6; i = ++i )
		{
			if (_targetTile.hasNextTile(i))
			{
				local forwardTile = _targetTile.getNextTile(i);
				local left = i - 1 < 0 ? 5 : i - 1;
				local LforwardTile;
				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}

				if (forwardTile.hasNextTile(left))
				{
					LforwardTile = forwardTile.getNextTile(left);
					if (this.Math.abs(LforwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
					{
						ret.push(LforwardTile);
					}
				}
				if (forwardTile.hasNextTile(i))
				{
					forwardTile = forwardTile.getNextTile(i);
					if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
					{
						ret.push(forwardTile);
					}
				}
			}
		}
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _user.getTile(), this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
		}
		local tiles = this.getAffectedTiles(_targetTile);
		this.Time.scheduleEvent(this.TimeUnit.Real, 700, this.onApply.bindenv(this), {
			Skill = this,
			User = _user,
			TargetTile = _targetTile,
			Tiles = tiles
		});
	}

	function onApply( _data )
	{
		local tiles = _data.Tiles;
		local p = {
			Type = "poison cloud",
			Tooltip = "Ядовитое облако, которое вредно для любого живого существа.",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = _data.User.isPlayerControlled(),
			Timeout = this.Time.getRound() + 5,
			Callback = onApplyPoisonCloud,
			function Applicable( _a )
			{
				return !_a.getFlags().has("undead");
			}

		};
		foreach( t in tiles )
		{
			t.clear();
			t.Type = 0;
			this.MapGen.get("tactical.tile.earth1").onFirstPass({
				X = t.SquareCoords.X,
				Y = t.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = true,
				SpawnObjects = false,
				ChanceToSpawnObject = 0
			});
			if (this.Math.rand(1, 3) == 1)
			{
				t.setBrush("tile_stone_02");
			}
			else
			{
				t.setBrush("tile_autumn_04");
			}
			if (this.Math.rand(1, 100) <= 80)
			{
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, t, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
					i = ++i;
				}
			}
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "poison cloud")
			{
				t.Properties.Effect.Timeout = this.Time.getRound() + 5;
			}
			else
			{
				if (t.Properties.Effect != null)
				{
					this.Tactical.Entities.removeTileEffect(t);
				}
				t.Properties.Effect = clone p;
				local particles = [];
				for( local i = 0; i < this.Const.Tactical.MiasmaParticles.len(); i = ++i )
				{
					particles.push(this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MiasmaParticles[i].Brushes, t, this.Const.Tactical.MiasmaParticles[i].Delay, this.Const.Tactical.MiasmaParticles[i].Quantity, this.Const.Tactical.MiasmaParticles[i].LifeTimeQuantity, this.Const.Tactical.MiasmaParticles[i].SpawnRate, this.Const.Tactical.MiasmaParticles[i].Stages));
				}
				this.Tactical.Entities.addTileEffect(t, t.Properties.Effect, particles);
				t.clear(this.Const.Tactical.DetailFlag.Scorchmark);
				t.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
			}
			if (t.IsOccupiedByActor && t.getEntity().isAttackable())
			{
				local e = t.getEntity();
				if (!e.isAlliedWith(_data.User))
				{
					if (this.Math.rand(1, 100) <= 35)
					{
						e.getSkills().add(this.new("scripts/skills/effects/withered_effect"));
					}
					this.attackEntity(_data.User, e);
				}
			}
		}
		local sounds = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], 1.3, _data.TargetTile.Pos);
	}

	function onApplyPoisonCloud( _tile, _entity )
	{
		if (_entity.getFlags().has("undead"))
		{
			return;
		}
		this.Tactical.spawnIconEffect("status_effect_00", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
		local sounds = [];
		if (_entity.getFlags().has("human"))
		{
			sounds = [
				"sounds/humans/human_coughing_01.wav",
				"sounds/humans/human_coughing_02.wav",
				"sounds/humans/human_coughing_03.wav",
				"sounds/humans/human_coughing_04.wav"
			];
		}
		else
		{
			sounds = [
				"sounds/enemies/miasma_appears_01.wav",
				"sounds/enemies/miasma_appears_02.wav",
				"sounds/enemies/miasma_appears_03.wav"
			];
		}
		this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Actor, _entity.getPos());
		local damage = this.Math.rand(10, 30);
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage;
		hitInfo.DamageArmor = damage * 2;
		hitInfo.DamageDirect = 0.5;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		hitInfo.Injuries = this.Const.Injury.Burning;
		hitInfo.IsPlayingArmorSound = false;
		if (this.Math.rand(1, 100) <= 35)
		{
			_entity.getSkills().add(this.new("scripts/skills/effects/withered_effect"));
		}
		_entity.onDamageReceived(_entity, null, hitInfo);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 20;
			_properties.DamageRegularMax = 50;
			_properties.DamageArmorMult = 0.5;
			_properties.RangedAttackBlockedChanceMult *= 0;
			if (_targetEntity != null)
			{
				local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());
				if (d <= 3)
				{
					_properties.DamageRegularMin += 50;
					_properties.DamageRegularMax += 50;
				}
			}
			if (this.Math.rand(1, 100) <= 11)
			{
				_properties.RangedSkill += 500;
			}
		}
	}

});

