this.ai_deathwind_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0,
		MainTile = null,
		AffectedTiles = []
	},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Ветер Смерти";
		this.m.Overlay = "active_41";
		this.m.KilledString = "Shredded";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_takeoff_01.wav",
			"sounds/enemies/vampire_takeoff_02.wav",
			"sounds/enemies/vampire_takeoff_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsTargetingActor = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local myTile = this.m.Container.getActor().getTile();
		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				ret.push(myTile.getNextTile(i));
			}
		}
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

	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
		if (this.m.MainTile != null && this.m.Cooldown == 0)
		{
			local actor = this.getContainer().getActor();
			local atile = actor.getTile();
			local stile = this.m.AffectedTiles;
			local mtile = this.m.MainTile;
			local rantile;
			this.Tactical.spawnSpriteEffect(this.m.Overlay, this.createColor("#ffffff"), atile, this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			this.Sound.play("sounds/enemies/lindwurm_gorge_01.wav", 1.5, mtile.Pos);
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, mtile.Pos);
			actor.setActionPoints(0);
			if (this.m.MainTile.IsVisibleForPlayer)
			{
				this.Tactical.getCamera().setPos(mtile.Pos);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function ( _skill )
				{
					this.Tactical.CameraDirector.addMoveSlowlyToTileEvent(0, mtile);
				}.bindenv(this), this);
			}
			this.Tactical.getCamera().quake(this.createVec(0, -1.0), 36.0, 0.16, 0.35);
			foreach( tile in this.m.AffectedTiles )
			{
				tile.Properties.IsMarkedForImpact = false;
				tile.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
			}
			for( local z = 0; z < stile.len(); z = ++z )
			{
				this.Time.scheduleEvent(this.TimeUnit.Virtual, z * 50, function ( _skill )
				{
			 		if (actor == null || !actor.isAlive() || actor.isDying())
					{
						return;
					}
					else
					{
						rantile = stile.remove(this.Math.rand(0, stile.len() - 1));
						for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
						{
							this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, rantile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
						}
						this.spawnAttackEffect(rantile, this.Const.Tactical.AttackEffectSlash);
						this.spawnAttackEffect(rantile, this.Const.Tactical.AttackEffectChop);
						this.spawnAttackEffect(rantile, this.Const.Tactical.AttackEffectSplit);
						this.spawnAttackEffect(rantile, this.Const.Tactical.AttackEffectThrust);
						this.spawnAttackEffect(rantile, this.Const.Tactical.AttackEffectBash);
						this.spawnAttackEffect(rantile, this.Const.Tactical.AttackEffectSwing);
						if (actor.isAlive() && rantile.IsOccupiedByActor && !actor.isAlliedWith(rantile.getEntity()))
						{
							local target = rantile.getEntity();
							local hitInfo = clone this.Const.Tactical.HitInfo;
							hitInfo.DamageRegular = this.Math.rand(100, 200);
							hitInfo.DamageArmor = hitInfo.DamageRegular * 1.1;
							hitInfo.DamageDirect = 0.5;
							hitInfo.BodyPart = 0;
							hitInfo.FatalityChanceMult = 0.0;
							hitInfo.Injuries = this.Const.Injury.BurningBody;
							target.onDamageReceived(actor, this, hitInfo);
						}
					}
				}.bindenv(this), this);
			}
			this.m.AffectedTiles = [];
			this.m.MainTile = null;
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, function ( _skill ){}.bindenv(this), this);
		}
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " casts death wind");
		}
		this.m.Cooldown = 1;
		this.m.AffectedTiles = this.getAffectedTiles(_targetTile);
		this.m.MainTile = _targetTile;
		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = true;
			tile.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.SpecialOverlay, false, true);
		}
		return true;
	}

	function onDeath( _fatalityType )
	{
		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = false;
			tile.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
		}
		this.m.AffectedTiles = [];
		this.m.MainTile = null;
	}

});

