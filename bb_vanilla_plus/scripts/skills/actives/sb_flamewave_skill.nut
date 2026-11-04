this.sb_flamewave_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 9,
		Skillcool = 9
	},
	function create()
	{
		this.m.ID = "actives.sb_flamewave_skill";
		this.m.Name = "Пламенная волна";
		this.m.Description = "Обжигает и оглушает несколько целей по прямой. Может поразить до 5 целей.";
		this.m.Icon = "ui/xx19.png";
		this.m.IconDisabled = "ui/xx19_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/fireball-erupted.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/fireball_on_effect.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsTargetingActor = false;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Восстановление: 9 ходов \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ходов"
		});
		return ret;
	}

	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}
		if (!_target.getCurrentProperties().IsImmuneToDaze)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
			if (!_target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_target) + " gained the negative effect (Dazed)");
			}
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local myTile = _user.getTile();
		local dir = myTile.getDirectionTo(_targetTile);

		if (_user.isAlliedWithPlayer())
		{
			for( local i = 0; i < this.Const.Tactical.HandgonneRightParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.HandgonneRightParticles[i].Brushes, _user.getTile(), this.Const.Tactical.HandgonneRightParticles[i].Delay, this.Const.Tactical.HandgonneRightParticles[i].Quantity, this.Const.Tactical.HandgonneRightParticles[i].LifeTimeQuantity, this.Const.Tactical.HandgonneRightParticles[i].SpawnRate, this.Const.Tactical.HandgonneRightParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.FireLanceRightParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.FireLanceRightParticles[i].Brushes, myTile, this.Const.Tactical.FireLanceRightParticles[i].Delay, this.Const.Tactical.FireLanceRightParticles[i].Quantity, this.Const.Tactical.FireLanceRightParticles[i].LifeTimeQuantity, this.Const.Tactical.FireLanceRightParticles[i].SpawnRate, this.Const.Tactical.FireLanceRightParticles[i].Stages, this.createVec(0, 0));
			}
		}
		else
		{
			for( local i = 0; i < this.Const.Tactical.HandgonneLeftParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.HandgonneLeftParticles[i].Brushes, _user.getTile(), this.Const.Tactical.HandgonneLeftParticles[i].Delay, this.Const.Tactical.HandgonneLeftParticles[i].Quantity, this.Const.Tactical.HandgonneLeftParticles[i].LifeTimeQuantity, this.Const.Tactical.HandgonneLeftParticles[i].SpawnRate, this.Const.Tactical.HandgonneLeftParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.FireLanceLeftParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.FireLanceLeftParticles[i].Brushes, myTile, this.Const.Tactical.FireLanceLeftParticles[i].Delay, this.Const.Tactical.FireLanceLeftParticles[i].Quantity, this.Const.Tactical.FireLanceLeftParticles[i].LifeTimeQuantity, this.Const.Tactical.FireLanceLeftParticles[i].SpawnRate, this.Const.Tactical.FireLanceLeftParticles[i].Stages, this.createVec(0, 0));
			}
		}

		for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, _targetTile, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
		}
		for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, _targetTile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -15));
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, _targetTile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
		}

		if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 20, function ( _tag )
			{
				if (_user.isAlive() && this.attackEntity(_user, _targetTile.getEntity(), false) && !_targetTile.IsEmpty)
				{
					this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
				}
			}.bindenv(this), null);
		}

		if (_targetTile.hasNextTile(dir))
		{
			local aatile = _targetTile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _tag )
			{
				for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, aatile, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
				}
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, aatile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -15));
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, aatile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
				}
				if (aatile.IsOccupiedByActor && aatile.getEntity().isAttackable())
				{
					if (_user.isAlive() && this.attackEntity(_user, aatile.getEntity(), false) && !aatile.IsEmpty)
					{
						this.applyEffectToTarget(_user, aatile.getEntity(), aatile);
					}
				}
			}.bindenv(this), null);

		if (aatile.hasNextTile(dir))
		{
			local bbtile = aatile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, function ( _tag )
			{
				for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, bbtile, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
				}
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, bbtile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -15));
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, bbtile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
				}
				if (bbtile.IsOccupiedByActor && bbtile.getEntity().isAttackable())
				{
					if (_user.isAlive() && this.attackEntity(_user, bbtile.getEntity(), false) && !bbtile.IsEmpty)
					{
						this.applyEffectToTarget(_user, bbtile.getEntity(), bbtile);
					}
				}
			}.bindenv(this), null);


		if (bbtile.hasNextTile(dir))
		{
			local cctile = bbtile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, function ( _tag )
			{
				for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, cctile, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
				}
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, cctile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -15));
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, cctile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
				}
				if (cctile.IsOccupiedByActor && cctile.getEntity().isAttackable())
				{
					if (_user.isAlive() && this.attackEntity(_user, cctile.getEntity(), false) && !cctile.IsEmpty)
					{
						this.applyEffectToTarget(_user, cctile.getEntity(), cctile);
					}
				}

			}.bindenv(this), null);

		if (cctile.hasNextTile(dir))
		{
			local ddtile = cctile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, function ( _tag )
			{
				for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, ddtile, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
				}
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, ddtile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -15));
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, ddtile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.7, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.7, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
				}
				if (ddtile.IsOccupiedByActor && ddtile.getEntity().isAttackable())
				{
					if (_user.isAlive() && this.attackEntity(_user, ddtile.getEntity(), false) && !ddtile.IsEmpty)
					{
						this.applyEffectToTarget(_user, ddtile.getEntity(), ddtile);
					}
				}
			}.bindenv(this), null);
		}

		}

		}

		}

		return true;
	}

	function onTargetSelected( _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);

		if (_targetTile.hasNextTile(dir))
		{
			local aatile = _targetTile.getNextTile(dir);
			if (aatile.IsOccupiedByActor || aatile.IsEmpty)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, aatile, aatile.Pos.X, aatile.Pos.Y);
			}

			if (aatile.hasNextTile(dir))
			{
				local bbtile = aatile.getNextTile(dir);
				if (bbtile.IsOccupiedByActor || bbtile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, bbtile, bbtile.Pos.X, bbtile.Pos.Y);
				}

			if (bbtile.hasNextTile(dir))
			{
				local cctile = bbtile.getNextTile(dir);
				if (cctile.IsOccupiedByActor || cctile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, cctile, cctile.Pos.X, cctile.Pos.Y);
				}

			if (cctile.hasNextTile(dir))
			{
				local ddtile = cctile.getNextTile(dir);
				if (ddtile.IsOccupiedByActor || ddtile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, ddtile, ddtile.Pos.X, ddtile.Pos.Y);
				}
			}

			}

			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
			_properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
			_properties.DamageDirectAdd = 0;
			_properties.DamageDirectMeleeAdd = 0;
			_properties.DamageDirectRangedAdd = 0;
			_properties.DamageDirectMult = 1;
			_properties.DamageRegularMin = 70;
			_properties.DamageRegularMax = 90;
			_properties.DamageArmorMult = 1.0;
			_properties.RangedAttackBlockedChanceMult *= 0;
		}
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

