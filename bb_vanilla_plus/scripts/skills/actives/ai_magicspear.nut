this.ai_magicspear <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Чародейская стрела";
		this.m.Overlay = "active_216";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/javelin_hit_03.wav"
		];
		this.m.SoundOnHitShield = [
			"sounds/combat/split_shield_01.wav",
			"sounds/combat/split_shield_02.wav",
			"sounds/combat/split_shield_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
		this.m.ChanceSmash = 5;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileType = this.Const.ProjectileType.xxmagicspear;
		this.m.ProjectileTimeScale = 1.1;
	}

	function onUpdate( _properties )
	{
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			this.m.MaxRange = 1;
		}
		else
		{
			this.m.MaxRange = this.m.ChanceSmash;
		}
	}

	function onUse( _user, _targetTile )
	{
		local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
		local myTile = _user.getTile();
		this.m.IsDoingAttackMove = false;
		this.getContainer().setBusy(true);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 0, function ( _skill )
		{
			if (_user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
			{
				this.Tactical.spawnProjectileEffect("effect_lightning_02", _user.getTile(), _targetTile, 0.8, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}.bindenv(this), this);
		for( local i = 0; i < 5; i = i )
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, (i * 20) + 20, function ( _skill )
			{
				if (_user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
				{
					this.Tactical.spawnProjectileEffect("effect_lightning_02", _user.getTile(), _targetTile, 0.8 - (i * 0.1), this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				}
			}.bindenv(this), this);
			i = ++i;
		}
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 350, function ( _skill )
		{
			if (_user.isAlive() &&  _targetTile.getEntity().isAlive())
			{
				_skill.attackEntity(_user, _targetTile.getEntity(), false);
			}
			_skill.m.IsDoingAttackMove = true;
			_skill.getContainer().setBusy(false);
		}.bindenv(this), this);
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 70;
			_properties.DamageRegularMax = 70;
			_properties.DamageArmorMult = 1.1;
			_properties.RangedAttackBlockedChanceMult *= 0;
		}
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
			{
				if (!this.Tactical.getNavigator().isTravelling(_targetEntity))
				{
					this.Tactical.getShaker().shake(_targetEntity, _targetEntity.getTile(), 2, this.Const.Combat.ShakeEffectSplitShieldColor, this.Const.Combat.ShakeEffectSplitShieldHighlight, this.Const.Combat.ShakeEffectSplitShieldFactor, 1.0, [
						"shield_icon"
					], 1.0);
				}
				shield.applyShieldDamage(5);
			}
			_targetEntity.checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
			_targetEntity.checkMorale(-1, -15, this.Const.MoraleCheckType.MentalAttack);
			if (!_targetEntity.checkMorale(0, -5, this.Const.MoraleCheckType.MentalAttack) && !_targetEntity.getCurrentProperties().IsStunned && !_targetEntity.getCurrentProperties().IsImmuneToStun)
			{
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/horrified_effect"));
			}
			for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[i].Brushes, _targetEntity.getTile(), this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
			}
		}
	}

});

