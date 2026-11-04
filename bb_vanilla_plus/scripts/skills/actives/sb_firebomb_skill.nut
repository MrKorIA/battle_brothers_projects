this.sb_firebomb_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 9,
		Skillcool = 9
	},
	function create()
	{
		this.m.ID = "actives.sb_firebomb_skill";
		this.m.Name = "24. Граната «Адский огонь»";
		this.m.Description = "Бросает гранату, испускающую злобное магическое пламя, сжигающее 7 плиток за 3 раунда. Сжигает существующие эффекты плиток, такие как дым или миазмы. Этот огонь сильнее обычного, горит дольше, игнорирует иммунитет к огню и сжигает всех врагов и союзников в указанной точке. Любой, кто закончит ход в зоне горения, загорится и получит урон — как друг, так и враг. \n[color=#8f1e1e]Requirements:[/color] 199 крон";
		this.m.Icon = "skills/active_209.png";
		this.m.IconDisabled = "skills/active_209_sw.png";
		this.m.Overlay = "active_209";
		this.m.SoundOnUse = [
			"sounds/combat/throw_ball_01.wav",
			"sounds/combat/throw_ball_02.wav",
			"sounds/combat/throw_ball_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.SoundVolume = 1.1;
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 0;
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
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 3;
		this.m.ProjectileType = this.Const.ProjectileType.Bomb1;
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
			text = "Дальность " + this.getMaxRange() + " плитки"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "20–30 единиц урона за ход здоровью и броне. (Этот урон навсегда парализует врагов, а не убивает их.)"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 9 ходов \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		if (this.Tactical.isActive())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/asset_money.png",
				text = "Собственный [color=#e6b71e]" + this.World.Assets.getMoney() + "[/color] крон"
			});
		}
		return ret;
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
				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
			}
		}
		return ret;
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
		local tiles = this.getAffectedTiles(_targetTile);
		this.Time.scheduleEvent(this.TimeUnit.Real, 250, this.onApply.bindenv(this), {
			Skill = this,
			User = _user,
			TargetTile = _targetTile,
			Tiles = tiles
		});
		return true;
	}

	function onApply( _data )
	{
		local tiles = _data.Tiles;
		local p = {
			Type = "Адский огонь",
			Tooltip = "Здесь бушует адский огонь, плавящий броню и плоть.",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = _data.User.isPlayerControlled(),
			Timeout = this.Time.getRound() + 3,
			Callback = onApplyMagicFire,
			function Applicable( _a )
			{
				return true;
			}

		};
		foreach( t in tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "Hellfire")
			{
				t.Properties.Effect.Timeout = this.Time.getRound() + 3;
			}
			else
			{
				if (t.Properties.Effect != null)
				{
					this.Tactical.Entities.removeTileEffect(t);
				}
				t.Properties.Effect = clone p;
				local particles = [];
				for( local i = 0; i < this.Const.Tactical.HellFireParticles.len(); i = ++i )
				{
					particles.push(this.Tactical.spawnParticleEffect(false, this.Const.Tactical.HellFireParticles[i].Brushes, t, this.Const.Tactical.HellFireParticles[i].Delay, this.Const.Tactical.HellFireParticles[i].Quantity, this.Const.Tactical.HellFireParticles[i].LifeTimeQuantity, this.Const.Tactical.HellFireParticles[i].SpawnRate, this.Const.Tactical.HellFireParticles[i].Stages));
				}
				this.Tactical.Entities.addTileEffect(t, t.Properties.Effect, particles);
				t.clear(this.Const.Tactical.DetailFlag.Scorchmark);
				t.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
			}
			if (t.IsOccupiedByActor)
			{
				onApplyMagicFire(t, t.getEntity());
			}
		}
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, _data.TargetTile.Pos);
	}

	function onApplyMagicFire( _tile, _entity )
	{
		this.Tactical.spawnIconEffect("status_effect_116", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
		local sounds = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, _entity.getPos());
		if (_entity.getCurrentProperties().DamageReceivedTotalMult > 0)
		{
			local dmg = this.Math.rand(20, 30);
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = 0;
			hitInfo.DamageArmor = dmg;
			hitInfo.DamageDirect = 0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1;
			hitInfo.FatalityChanceMult = 0;
			_entity.onDamageReceived(_entity, null, hitInfo);
			hitInfo.BodyPart = this.Const.BodyPart.Head;
			_entity.onDamageReceived(_entity, null, hitInfo);

			_entity.playSound(this.Const.Sound.ActorEvent.DamageReceived, 0.8);
			this.Tactical.getShaker().shake(_entity, _entity.getTile(), 4);

			dmg = this.Math.rand(20, 30);
			if (_entity.getHitpoints() <= dmg)
			{
				_entity.getSkills().add(this.new("scripts/skills/effects/ai_stun_effect"));
				_entity.getSkills().add(this.new("scripts/skills/effects/ai_mortalwound_effect"));
			}
			if (!_entity.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " suffered HP damage.");
			}
			_entity.setHitpoints(this.Math.max(_entity.getHitpoints() - dmg, 1));
			local fakeb = this.new("scripts/skills/actives/ai_fakebuff");
			fakeb.m.Overlay = "";
			_entity.getSkills().add(fakeb);
		}
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

