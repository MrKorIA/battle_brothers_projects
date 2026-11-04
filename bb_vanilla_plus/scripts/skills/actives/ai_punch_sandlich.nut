this.ai_punch_sandlich <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0,
		MainTile = null,
		AffectedTiles = []
	},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Заклинание";
		this.m.Description = "";
		this.m.KilledString = "Electrocuted";
		this.m.SoundOnUse = ["sounds/enemies/horror_spell_03.wav"];
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
		this.m.InjuriesOnBody = this.Const.Injury.BurningAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningAndPiercingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 7;
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [];
		local size = this.Tactical.getMapSize();
		for( local y = 0; y < size.Y; y = ++y )
		{
			local tile = this.Tactical.getTileSquare(_targetTile.SquareCoords.X, y);
			if (!tile.IsEmpty && !tile.IsOccupiedByActor)
			{
			}
			else
			{
				ret.push(tile);
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
			local ttile = this.m.MainTile;
			local rantile;
			this.Tactical.spawnSpriteEffect("active_216", this.createColor("#ffffff"), atile, this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			actor.setActionPoints(0);
			if (this.Const.DLC.Unhold && this.Const.DLC.Wildmen && this.Const.DLC.Desert)
			{
				this.Sound.play("sounds/enemies/dlc6/lightning_impact_0" + this.Math.rand(1, 4) + ".wav", 1.0, this.m.AffectedTiles[0].Pos);
			}
			else
			{
				this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", 0.9, this.m.AffectedTiles[0].Pos);
			}
			if (this.m.MainTile.IsVisibleForPlayer)
			{
				this.Tactical.getCamera().setPos(ttile.Pos);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function ( _skill )
				{
					this.Tactical.CameraDirector.addMoveSlowlyToTileEvent(0, ttile);
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
				this.Time.scheduleEvent(this.TimeUnit.Virtual, z * 30, function ( _skill )
				{
			 		if (actor == null || !actor.isAlive() || actor.isDying())
					{
						return;
					}
					else
					{
						rantile = stile.remove(0);
						for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
						{
							this.Tactical.spawnParticleEffect(true, this.Const.Tactical.LightningParticles[i].Brushes, rantile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
						}
						if (rantile.Type != this.Const.Tactical.TerrainType.ShallowWater && rantile.Type != this.Const.Tactical.TerrainType.DeepWater)
						{
							rantile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
							rantile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
						}
						if (actor.isAlive() && rantile.IsOccupiedByActor && !actor.isAlliedWith(rantile.getEntity()))
						{
							local target = rantile.getEntity();
							local hitInfo = clone this.Const.Tactical.HitInfo;
							hitInfo.DamageRegular = this.Math.rand(20, 50);
							hitInfo.DamageArmor = hitInfo.DamageRegular * 0.9;
							hitInfo.DamageDirect = 0.7;
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
		if (!this.getContainer().getActor().getFlags().has("sandlich") || this.m.Cooldown != 0)
		{
			local target = _targetTile.getEntity();
			target.getSkills().add(this.new("scripts/skills/effects/withered_effect"));
			local effect = this.new("scripts/skills/effects/bleeding_effect");
			effect.setDamage(this.Math.rand(1, 5));
			target.getSkills().add(effect);
			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " withers");
				this.Tactical.spawnSpriteEffect("active_217", this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			}
			return true;
		}

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " summons lightning");
			this.Tactical.spawnSpriteEffect("active_216", this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
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

