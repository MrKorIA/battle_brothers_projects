this.sb_cannon_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SkillFire = 0,
		Cooldown = 7,
		Skillcool = 7,
		AffectedTiles = []
	},
	function create()
	{
		this.m.ID = "actives.sb_cannon_skill";
		this.m.Name = "11. Пушечный обстрел";
		this.m.Description = "Через 2 хода бомбардируйте выбранную область. \n[color=#8f1e1e]Требование:[/color] 199 Крон";
		this.m.Icon = "ui/xx49.png";
		this.m.IconDisabled = "ui/xx49_sw.png";
		this.m.Overlay = "active_212";
		this.m.SoundOnUse = [
			"sounds/combat/perfect_focus_01.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/lindwurm_tail_slam_hit_01.wav",
			"sounds/enemies/lindwurm_tail_slam_hit_02.wav",
			"sounds/enemies/lindwurm_tail_slam_hit_03.wav",
			"sounds/enemies/lindwurm_tail_slam_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsTargetingActor = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 7;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Урон: [color=" + this.Const.UI.Color.PositiveValue + "]70 ~ 150[/color] (200% урона броне)"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 7 ходов \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
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

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local myTile = this.m.Container.getActor().getTile();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				ret.push(_targetTile.getNextTile(i));
			}
		}

		return ret;
	}

	function onTargetSelected( _targetTile )
	{
		local affectedTiles = this.getAffectedTiles(_targetTile);

		foreach( t in affectedTiles )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.SkillFire = 3;
		this.m.Skillcool = 0;
		this.m.AffectedTiles = this.getAffectedTiles(_targetTile);
		this.World.Assets.addMoney(-199);
		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = true;
			tile.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.SpecialOverlay, false, true);
		}
		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
		this.m.SkillFire = this.Math.max(0, this.m.SkillFire - 1);
		if (this.m.AffectedTiles.len() != 0 && this.m.SkillFire == 1)
		{
			local actor = this.getContainer().getActor();
			local atile = actor.getTile();
			local stile = this.m.AffectedTiles;
			local rantile;
			this.Tactical.spawnSpriteEffect("active_211", this.createColor("#ffffff"), atile, this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration + this.m.Delay, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 0.9, this.m.AffectedTiles[0].Pos);
			this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", 0.9, this.m.AffectedTiles[0].Pos);
			this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);
			foreach( tile in this.m.AffectedTiles )
			{
				tile.Properties.IsMarkedForImpact = false;
				tile.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
			}
			for( local z = 0; z < stile.len(); z = ++z )
			{
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 0 + (z * this.Math.rand(80, 200)), function ( _skill )
				{
			 		if (actor == null || !actor.isAlive() || actor.isDying())
					{
						z = 100;
					}
					else
					{
						rantile = stile.remove(this.Math.rand(0, stile.len() - 1));
						this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 0.9, rantile.Pos);
						this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", 0.9, rantile.Pos);
						for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
						{
							this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, rantile, this.Const.Tactical.MortarImpactParticles[i].Delay, this.Const.Tactical.MortarImpactParticles[i].Quantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].SpawnRate, this.Const.Tactical.MortarImpactParticles[i].Stages, this.createVec(0, -30));
						}
						if (rantile.Type != this.Const.Tactical.TerrainType.ShallowWater && rantile.Type != this.Const.Tactical.TerrainType.DeepWater)
						{
							rantile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
							rantile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
						}
						if (actor.isAlive() && rantile.IsOccupiedByActor)
						{
							local target = rantile.getEntity();
							if (target.getMoraleState() != this.Const.MoraleState.Ignore)
							{
								target.checkMorale(-1, 0);
								target.getSkills().add(this.new("scripts/skills/effects/shellshocked_effect"));
							}
							local hitInfo = clone this.Const.Tactical.HitInfo;
							hitInfo.DamageRegular = this.Math.rand(70, 150);
							hitInfo.DamageArmor = hitInfo.DamageRegular * 2;
							hitInfo.DamageDirect = 0.4;
							hitInfo.BodyPart = 0;
							hitInfo.FatalityChanceMult = 0.0;
							hitInfo.Injuries = this.Const.Injury.BurningAndPiercingBody;
							target.onDamageReceived(actor, this, hitInfo);
						}
					}
				}.bindenv(this), this);
			}
			this.m.AffectedTiles = [];
		}
	}

	function onDeath( _fatalityType )
	{
		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = false;
			tile.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
		}
		this.m.AffectedTiles = [];
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
		if (this.m.AffectedTiles.len() != 0)
		{
			return false;
		}
		if (this.m.SkillFire != 0)
		{
			return false;
		}
		if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}
		return true;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
		this.m.SkillFire = 0;
		this.m.AffectedTiles = [];
	}

	function onCombatStarted()
	{
		this.m.Skillcool = this.m.Cooldown;
		this.m.SkillFire = 0;
		this.m.AffectedTiles = [];
	}

});

