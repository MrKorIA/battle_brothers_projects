this.ai_lightning_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.aoe_a";
		this.m.Name = "Верховный взрыв";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_takeoff_01.wav",
			"sounds/enemies/vampire_takeoff_02.wav",
			"sounds/enemies/vampire_takeoff_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.SoundOnHitDelay = 0;
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
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 15;
		this.m.MaxLevelDifference = 4;
	}

	function applyEffectToTargets( _tag )
	{
		local user = _tag.User;
		local targets = _tag.Targets;
		foreach( t in targets )
		{
			for( local i = 0; i < this.Const.Tactical.SpiritWalkEndParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SpiritWalkEndParticles[i].Brushes, t, this.Const.Tactical.SpiritWalkEndParticles[i].Delay, this.Const.Tactical.SpiritWalkEndParticles[i].Quantity, this.Const.Tactical.SpiritWalkEndParticles[i].LifeTimeQuantity, this.Const.Tactical.SpiritWalkEndParticles[i].SpawnRate, this.Const.Tactical.SpiritWalkEndParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[i].Brushes, t, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, t, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.5, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
			}
			for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, t, this.Const.Tactical.MortarImpactParticles[i].Delay, this.Const.Tactical.MortarImpactParticles[i].Quantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].SpawnRate, this.Const.Tactical.MortarImpactParticles[i].Stages, this.createVec(0, -30));
			}
			t.clear(this.Const.Tactical.DetailFlag.Scorchmark);
			t.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
			if (t.IsOccupiedByActor && t.getEntity().isAttackable())
			{
				local e = t.getEntity();
				if (!e.isAlliedWith(user))
				{
					e.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
					local ska = this.new("scripts/skills/effects/shellshocked_effect");
					ska.m.SoundOnUse = [
						"sounds/humans/human_coughing_01.wav",
						"sounds/humans/human_coughing_02.wav",
						"sounds/humans/human_coughing_03.wav",
						"sounds/humans/human_coughing_04.wav"
					];
					e.getSkills().add(ska);
					this.attackEntity(user, e, false);
				}
			}
		}
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

			if (forwardTile.hasNextTile(dir))
			{
				forwardTile = forwardTile.getNextTile(dir);

				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
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

			if (forwardTile.hasNextTile(dir))
			{
				forwardTile = forwardTile.getNextTile(dir);

				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
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

			if (forwardTile.hasNextTile(dir))
			{
				forwardTile = forwardTile.getNextTile(dir);

				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
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
		for( local i = 0; i < this.Const.Tactical.SpiritWalkStartParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SpiritWalkStartParticles[i].Brushes, _user.getTile(), this.Const.Tactical.SpiritWalkStartParticles[i].Delay, this.Const.Tactical.SpiritWalkStartParticles[i].Quantity, this.Const.Tactical.SpiritWalkStartParticles[i].LifeTimeQuantity, this.Const.Tactical.SpiritWalkStartParticles[i].SpawnRate, this.Const.Tactical.SpiritWalkStartParticles[i].Stages);
		}
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local targetTile = _tag.TargetTile;
		local myTile = user.getTile();
		local dir = myTile.getDirectionTo(targetTile);
		local affectedTiles = this.getAffectedTiles(targetTile);
		local tag = {
			Skill = _tag.Skill,
			User = user,
			Targets = affectedTiles
		};
		local stun = this.new("scripts/skills/effects/ai_stun_effect");
		user.getSkills().add(stun);
		stun.setTurns(2);
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, user.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, this.applyEffectToTargets.bindenv(this), tag);
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 50;
			_properties.DamageRegularMax = 80;
			_properties.DamageArmorMult = 1.0;
			_properties.RangedAttackBlockedChanceMult *= 0;
			if (_targetEntity != null)
			{
				local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());
				if (d <= 2)
				{
					_properties.DamageRegularMin += 50;
					_properties.DamageRegularMax += 50;
					_properties.RangedSkill += 20;
				}
				else if (d <= 4)
				{
					_properties.DamageRegularMin += 20;
					_properties.DamageRegularMax += 20;
					_properties.RangedSkill += 10;
				}
			}
		}
	}

});

