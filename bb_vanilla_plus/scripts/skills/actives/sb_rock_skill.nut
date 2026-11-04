this.sb_rock_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_rock_skill";
		this.m.Name = "53. Бросок валуна";
		this.m.Description = "Бросает в противника огромный валун, нанося урон. Тип урона: дальний. Применяются перки дуэлянта. Может поразить голову. (Навык дальнего боя)";
		this.m.Icon = "ui/xx17.png";
		this.m.IconDisabled = "ui/xx17_sw.png";
		this.m.Overlay = "active_193";
		this.m.SoundOnUse = [
			"sounds/combat/shatter_01.wav",
			"sounds/combat/shatter_02.wav",
			"sounds/combat/shatter_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
		];
		this.m.SoundVolume = 1.3;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 200;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = false;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 25;
		this.m.MinRange = 2;
		this.m.MaxRange = 5;
		this.m.MaxLevelDifference = 4;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.ProjectileType = this.Const.ProjectileType.Rock;
		this.m.ProjectileTimeScale = 1.4;
		this.m.IsProjectileRotated = true;
		this.m.ChanceSmash = 80;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет радиус действия " + this.getMaxRange() + " клеток."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Шанс попадания определяется более высоким из навыков ближнего и дальнего боя. -4% за каждую клетку расстояния."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Цели со щитом всегда будут поражены. (10~50 урона щитам)"
		});
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использовано, поскольку этот персонаж участвует в ближнем бою.[/color]"
			});
		}
		return ret;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		if (!actor.isAlive())
		{
			return false;
		}
		else if (actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			return false;
		}
		return true;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _targetEntity.getTile(), this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
			}
		}
	}

	function onApplyShieldDamage( _tag )
	{
		local conditionBefore = _tag.Shield.getCondition();
		_tag.Shield.applyShieldDamage(_tag.Damage);
		if (_tag.Shield.getCondition() == 0)
		{
			if (!_tag.User.isHiddenToPlayer() && _tag.TargetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_tag.User) + " has destroyed " + this.Const.UI.getColorizedEntityName(_tag.TargetTile.getEntity()) + "\'s shield");
			}
		}
		else
		{
			if (!_tag.User.isHiddenToPlayer() && _tag.TargetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_tag.TargetTile.getEntity()) + "\'s shield is hit for [b]" + (conditionBefore - _tag.Shield.getCondition()) + "[/b] damage");
			}

			if (_tag.Skill.m.SoundOnHitShield.len() != 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHitShield[this.Math.rand(0, _tag.Skill.m.SoundOnHitShield.len() - 1)], this.Const.Sound.Volume.Skill, _tag.TargetTile.getEntity().getPos());
			}
		}
		if (!this.Tactical.getNavigator().isTravelling(_tag.TargetTile.getEntity()))
		{
			this.Tactical.getShaker().shake(_tag.TargetTile.getEntity(), _tag.User.getTile(), 2, this.Const.Combat.ShakeEffectSplitShieldColor, this.Const.Combat.ShakeEffectSplitShieldHighlight, this.Const.Combat.ShakeEffectSplitShieldFactor, 1.0, [
				"shield_icon"
			], 1.0);
		}
		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _tag.TargetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
		}
	}

	function onUse( _user, _targetTile )
	{
		local targetEntity = _targetTile.getEntity();
		local shield = targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
		{
			local flip = !this.m.IsProjectileRotated && targetEntity.getPos().X > _user.getPos().X;
			local time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onApplyShieldDamage.bindenv(this), {
				User = _user,
				Skill = this,
				TargetTile = _targetTile,
				Shield = shield,
				Damage = this.Math.rand(10, 50)
			});
		}
		else
		{
			this.attackEntity(_user, _targetTile.getEntity());
		}
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			local offh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			local mcs = actor.getCurrentProperties().MeleeSkill;
			local rcs = actor.getCurrentProperties().RangedSkill;
			if (mcs > rcs)
			{
				_properties.RangedSkill = mcs;
			}
			_properties.DamageRegularMin = 30;
			_properties.DamageRegularMax = 150;
			_properties.DamageArmorMult = 1.5;
			_properties.HitChanceAdditionalWithEachTile += -4;
			if (actor.getSkills().hasSkill("perk.duelist"))
			{
				_properties.DamageDirectAdd += 0.01;
			}
		}
	}

});

