this.sb_fireball_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3,
		Skillcool = 3
	},
	function create()
	{
		this.m.ID = "actives.sb_fireball_skill";
		this.m.Name = "Огненный шар";
		this.m.Description = "Создаёт мощное заклинание «Огненный шар», которое взрывается в указанном месте. Может поразить несколько целей.";
		this.m.Icon = "ui/xx20.png";
		this.m.IconDisabled = "ui/xx20_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/fireball_on_use.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 227;
		this.m.IsSerialized = true;
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
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 20;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileTimeScale = 1.8;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
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
			text = "+9% к шансу попадания, игнорирует препятствия и атакует только выбранные цели, может поразить до 4 целей. +2 к максимальному урону за уровень персонажа"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Восстановление : 3 хода \nВосстановится через: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход(а)"
		});
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использовано, так как этот персонаж участвует в ближнем бою.[/color]"
			});
		}
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local myTile = _user.getTile();
		local time = 0;
		local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
		time = this.Tactical.spawnProjectileEffect("xxprojectile_06", _user.getTile(), _targetTile, 1.5, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
		if (myTile.IsVisibleForPlayer)
		{
			if (_user.isAlliedWithPlayer())
			{
				for( local i = 0; i < this.Const.Tactical.HandgonneRightParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.HandgonneRightParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
			else
			{
				for( local i = 0; i < this.Const.Tactical.HandgonneLeftParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.HandgonneLeftParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
		}
		for( local i = 0; i < 3; i = i )
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, (i * 200) + 100, function ( _skill )
			{
				if (_user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
				{
					this.Tactical.spawnProjectileEffect("xxprojectile_06", _user.getTile(), _targetTile, 0.7 - (i * 0.2), this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				}
			}.bindenv(this), this);
			i = ++i;
		}
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, time + 50, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local targetTile = _tag.TargetTile;
		local affectedTiles = this.getAffectedTiles(targetTile);
		for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, targetTile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.5, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
		}
		for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, targetTile, this.Const.Tactical.MortarImpactParticles[i].Delay, this.Const.Tactical.MortarImpactParticles[i].Quantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].SpawnRate, this.Const.Tactical.MortarImpactParticles[i].Stages, this.createVec(0, -30));
		}
		this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 1.6, _tag.TargetTile);
		local tag = {
			Skill = _tag.Skill,
			User = user,
			Targets = affectedTiles
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, this.applyEffectToTargets.bindenv(this), tag);
		return true;
	}

	function applyEffectToTargets( _tag )
	{
		local user = _tag.User;
		local targets = _tag.Targets;

		foreach( t in targets )
		{
			for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, t, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
			}
			for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, t, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.5, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
			}
			if (!t.IsOccupiedByActor || !t.getEntity().isAttackable())
			{
				continue;
			}
			local target = t.getEntity();
			local success = this.attackEntity(user, target, false);
			if (success && target.isAlive() && !target.isDying() && t.IsVisibleForPlayer)
			{
				if (user.getPos().X <= target.getPos().X)
				{
					for( local i = 0; i < this.Const.Tactical.ShrapnelLeftParticles.len(); i = ++i )
					{
						local effect = this.Const.Tactical.ShrapnelLeftParticles[i];
						this.Tactical.spawnParticleEffect(false, effect.Brushes, t, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
					}
				}
				else
				{
					for( local i = 0; i < this.Const.Tactical.ShrapnelRightParticles.len(); i = ++i )
					{
						local effect = this.Const.Tactical.ShrapnelRightParticles[i];
						this.Tactical.spawnParticleEffect(false, effect.Brushes, t, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
					}
				}
			}
		}
	}

	function onTargetSelected( _targetTile )
	{
		local affectedTiles = this.getAffectedTiles(_targetTile);
		foreach( t in affectedTiles )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
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
		}

		local left = dir - 1 < 0 ? 5 : dir - 1;

		if (_targetTile.hasNextTile(left))
		{
			local forwardTile = _targetTile.getNextTile(left);

			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
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
		}

		return ret;
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return actor.isAlive() && this.skill.isUsable() && !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()) && this.m.Skillcool >= this.m.Cooldown;
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
			local actor = this.getContainer().getActor();
			_properties.DamageRegularMin = 50;
			_properties.DamageRegularMax = actor.getLevel() * 2 + 80;
			_properties.DamageArmorMult = 1.0;
			_properties.RangedSkill += 9;
			_properties.RangedAttackBlockedChanceMult *= 0;
		}
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

