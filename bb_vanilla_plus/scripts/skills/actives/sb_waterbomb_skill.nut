this.sb_waterbomb_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 7,
		Skillcool = 7
	},
	function create()
	{
		this.m.ID = "actives.sb_waterbomb_skill";
		this.m.Name = "Болотная бомба";
		this.m.Description = "Заполняет 7 клеток большим количеством воды, нанося урон и превращая местность в болото.";
		this.m.Icon = "ui/xx74.png";
		this.m.IconDisabled = "ui/xx74_sw.png";
		this.m.Overlay = "active_97";
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
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
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
			text = "Дальность " + this.getMaxRange() + " клеток"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Обрушивает на цели поток воды и наносит 10~70 урона, игнорирующего броню. (Этот урон калечит врагов, а не убивает их)"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 7 ходов \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход(а)"
		});
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
		local time = 250;
		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		{
			local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
			if (_user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
			{
				time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}
		local tiles = this.getAffectedTiles(_targetTile);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function ( _skill )
		{
			foreach( t in tiles )
			{
				t.clear();
				t.Type = 0;
				this.MapGen.get("tactical.tile.swampx1").onFirstPass({
					X = t.SquareCoords.X,
					Y = t.SquareCoords.Y,
					W = 1,
					H = 1,
					IsEmpty = true,
					SpawnObjects = false
				});
				if (this.Math.rand(1, 100) <= 20)
				{
					local tiletype = [
						"swamp_grass_10_reflect",
						"desert_grass_03_water",
						"desert_grass_04_water",
						"desert_grass_05_water",
						"autumn_moss_01",
						"autumn_moss_02",
						"autumn_moss_03",
						"swamp_moss_01"
					];
					t.clear(this.Const.Tactical.DetailFlag.Scorchmark);
					t.spawnDetail(tiletype[this.Math.rand(0, tiletype.len() - 1)], this.Const.Tactical.DetailFlag.Scorchmark, false, true);
				}
				if (t.IsOccupiedByActor && !t.getEntity().isNonCombatant() && t.getEntity().getHitpointsMax() > 1)
				{
					local target = t.getEntity();
					local tk = target.getSkills();
					if (t.IsVisibleForPlayer)
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " промок и потерял ОЗ.");
					}
					target.getSkills().add(this.new("scripts/skills/effects/ai_soaked_effect"));
					if (!tk.hasSkill("actives.gruesome_feast") && !tk.hasSkill("actives.throw_golem"))
					{
						target.sinkIntoGround(0.3);
					}
					else
					{
						this.Tactical.getShaker().shake(target, t, 3, this.createColor("#ffffff"), this.createColor("#5e737a"), 0.5, 1.0, this.Const.ShakeCharacterLayers[this.Const.BodyPart.All], 2.0);
					}
					for( local i = 0; i < this.Const.Tactical.AcidParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.AcidParticles[i].Brushes, t, this.Const.Tactical.AcidParticles[i].Delay, this.Const.Tactical.AcidParticles[i].Quantity, this.Const.Tactical.AcidParticles[i].LifeTimeQuantity, this.Const.Tactical.AcidParticles[i].SpawnRate, this.Const.Tactical.AcidParticles[i].Stages);
					}
					this.Tactical.spawnIconEffect("status_effect_50", t, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
					this.Sound.play("sounds/vomit_01.wav", this.Const.Sound.Volume.Skill * 1.0, target.getPos());
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, function ( _skill )
					{
					   if (target.isAlive())
					   {
						if (!tk.hasSkill("actives.gruesome_feast") && !tk.hasSkill("actives.throw_golem"))
						{
							target.riseFromGround(0.7);
						}
						if (target.getCurrentProperties().DamageReceivedTotalMult > 0)
						{	
							local dmg = this.Math.rand(10, 70);
							if (target.getHitpoints() <= dmg)
							{
								target.getSkills().add(this.new("scripts/skills/effects/ai_stun_effect"));
								target.getSkills().add(this.new("scripts/skills/effects/ai_mortalwound_effect"));
							}
							if (!target.isHiddenToPlayer())
							{
								this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " получил урон по ОЗ.");
							}
							target.setHitpoints(this.Math.max(target.getHitpoints() - dmg, 1));
							local fakeb = this.new("scripts/skills/actives/ai_fakebuff");
							fakeb.m.Overlay = "";
							target.getSkills().add(fakeb);
						}
					   }
					}.bindenv(this), this);
				}
			}
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, _targetTile.Pos);
		}.bindenv(this), this);
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
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

