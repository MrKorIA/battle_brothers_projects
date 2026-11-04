this.sb_manaforce_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3,
		Skillcool = 3
	},
	function create()
	{
		this.m.ID = "actives.sb_manaforce_skill";
		this.m.Name = "Гроза";
		this.m.Description = "Наносит урон от дальнего боя случайным врагам в радиусе 2 клеток вокруг вас 10 раз. Заклинатель не может действовать в течение 2 ходов.";
		this.m.Icon = "ui/xx41.png";
		this.m.IconDisabled = "ui/xx41_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = true;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 20;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "+20% к шансу попадания, игнорирует препятствия"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Targets with soaked or similar debuffs take 50% more damage."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cooldown: 3 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local myTile = _user.getTile();
		local targets = [];
		local visualTiles = [];
		local xxap = _user.getActionPoints();
		_user.setActionPoints(0);		
		local size = this.Tactical.getMapSize();
		for( local x = 0; x < size.X; x = ++x )
		{
			for( local y = 0; y < size.Y; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				if (myTile.getDistanceTo(tile) <= 2 && tile != myTile)
				{
					visualTiles.push(tile);
					if (!tile.IsEmpty && tile.IsOccupiedByActor && tile.getEntity().isAttackable() && !tile.getEntity().isAlliedWith(_user))
					{
						targets.push(tile.getEntity());
					}
				}
			}
		}
		if (this.Const.DLC.Unhold && this.Const.DLC.Wildmen && this.Const.DLC.Desert)
		{
			this.Sound.play("sounds/enemies/dlc6/cast_lightning_0" + this.Math.rand(1, 4) + ".wav", 1.5, myTile.Pos);
			this.Sound.play("sounds/enemies/dlc6/lightning_impact_0" + this.Math.rand(1, 4) + ".wav", 1.5, myTile.Pos);
			this.Sound.play("sounds/combat/dlc2/legendary_lightning_0" + this.Math.rand(1, 2) + ".wav", 1.5, myTile.Pos);
		}
		if (_user.hasSprite("xlightning_eye"))
		{
			_user.getSprite("xlightning_eye").Visible = false;
			_user.removeSprite("xlightning_eye");
		}
		_user.addSprite("xlightning_eye");
		_user.getSprite("xlightning_eye").setBrush("zombie_rage_eyes");
		_user.getSprite("xlightning_eye").Visible = true;
		_user.getSprite("xlightning_eye").Color = this.createColor("#008cff");
		if (_user.hasSprite("arms_icon"))
		{
			_user.removeSprite("arms_icon");
			_user.addSprite("arms_icon")
			_user.getItems().updateAppearance();
		}
		for( local i = 0; i < 20; i = ++i )
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, i * 50, function ( _skill )
			{
				if (visualTiles.len() == 0) return;
				local effectT = visualTiles[this.Math.rand(0, visualTiles.len() - 1)];
				for( local j = 0; j < this.Const.Tactical.LightningParticles.len(); j = ++j )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[j].Brushes, effectT, this.Const.Tactical.LightningParticles[j].Delay, this.Const.Tactical.LightningParticles[j].Quantity, this.Const.Tactical.LightningParticles[j].LifeTimeQuantity, this.Const.Tactical.LightningParticles[j].SpawnRate, this.Const.Tactical.LightningParticles[j].Stages);
				}
				if (this.Math.rand(1, 100) <= 50)
				{
					effectT.clear(this.Const.Tactical.DetailFlag.Scorchmark);
					effectT.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
				}
			}.bindenv(this), this);
		}
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 900, function ( _skill )
		{
			if (_user.hasSprite("xlightning_eye"))
			{
				_user.getSprite("xlightning_eye").Visible = false;
				_user.removeSprite("xlightning_eye");
			}
			_user.setActionPoints(xxap);
			_user.setDirty(true);
			this.getContainer().update();
			foreach( t in targets )
			{
				if (!_user.isAlive() || _user.isDying()) break;
				this.Sound.play("sounds/combat/dlc2/legendary_lightning_0" + this.Math.rand(1, 2) + ".wav", 1.0, t.getPos());
				for( local j = 0; j < this.Const.Tactical.LightningParticles.len(); j = ++j )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[j].Brushes, t.getTile(), this.Const.Tactical.LightningParticles[j].Delay, this.Const.Tactical.LightningParticles[j].Quantity, this.Const.Tactical.LightningParticles[j].LifeTimeQuantity, this.Const.Tactical.LightningParticles[j].SpawnRate, this.Const.Tactical.LightningParticles[j].Stages);
				}
				_skill.attackEntity(_user, t, false);
			}			
		}.bindenv(this), this);
		return true;
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
			_properties.DamageRegularMin = 70;
			_properties.DamageRegularMax = 100;
			_properties.DamageArmorMult = 1.0;
			_properties.RangedSkill += 15;
			_properties.RangedAttackBlockedChanceMult *= 0;
			if (_targetEntity != null)
			{
				local ts = _targetEntity.getSkills();
				if (ts.hasSkill("effects.ai_soaked_effect") || ts.hasSkill("effects.sb_rain_effect") || ts.hasSkill("effects.holy_water"))
				{
					_properties.DamageTotalMult += 0.5;
				}
			}
		}
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else
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

