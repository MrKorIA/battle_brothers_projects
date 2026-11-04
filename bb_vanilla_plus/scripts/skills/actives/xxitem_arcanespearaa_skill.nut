this.xxitem_arcanespearaa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.aoe_a";
		this.m.Name = "Таинственные стрелы";
		this.m.Description = "Выпускает несколько снарядов, наполненных тайной энергией, чтобы атаковать врагов в заданном месте. Снаряды могут быть заблокированы препятствиями.";
		this.m.Icon = "skills/active_202.png";
		this.m.IconDisabled = "skills/active_202_sw.png";
		this.m.Overlay = "active_202";
		this.m.SoundOnUse = [
			"sounds/combat/bolt_shot_01.wav",
			"sounds/combat/bolt_shot_02.wav",
			"sounds/combat/bolt_shot_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.SoundVolume = 0.9;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = true;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = false;
		this.m.IsTargetingActor = false;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 25;
		this.m.MinRange = 2;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
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
			icon = "ui/icons/hitchance.png",
			text = "+5% к шансу поразить цель и -1% за каждую клетку расстояния до цели."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Наносит 5 ударов по случайным целям в области действия. Может наносить несколько ударов по одной цели."
		});
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использован, поскольку этот персонаж участвует в ближнем бою.[/color]"
			});
		}
		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onAfterUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			this.m.MaxRange = 6;
		}
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			this.Tactical.spawnSpriteEffect("sparkleflare_1", this.createColor("#ccf1ff"), _targetEntity.getTile(), 0, 40, 0.9, 0.9, -10, 400, 300);
			this.Tactical.spawnSpriteEffect("sparkleflare_2", this.createColor("#ccf1ff"), _targetEntity.getTile(), 0, 40, 0.9, 0.4, 10, 150, 350);
		}
	}

	function onUse( _user, _targetTile )
	{
		local mainh = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (this.getContainer().getActor().isPlayerControlled() && mainh.m.Condition < 3)
		{
			for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[i].Brushes, this.getContainer().getActor().getTile(), this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
			}
			this.Sound.play("sounds/combat/weapon_break_01.wav", this.Const.Sound.Volume.Skill * 2.1, this.getContainer().getActor().getPos());
			this.m.Container.getActor().getSprite("arms_icon").setBrush("icon_xx_weapon_15");
			return true;
		}
		local xxtile = [];
		local ttarget;
		local xxattackOK = 0;
		local xxtileE = [];
		xxtileE.push(_targetTile);
		local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
		if (!_targetTile.IsEmpty && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable())
		{
			xxtile.push(_targetTile.getEntity());
			xxattackOK = 1;
			ttarget = _targetTile.getEntity();
		}
		for( local i = 0; i < 6; i = i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				xxtileE.push(tile);
				if (!tile.IsEmpty && tile.IsOccupiedByActor && tile.getEntity().isAttackable())
				{
					xxtile.push(tile.getEntity());
					xxattackOK = 1;
				}
			}
			i = ++i;
		}
		local myTile = _user.getTile();
		local dir = _targetTile.getDirectionTo(myTile);
		local xztile = [];
		if (myTile.hasNextTile(dir))
		{
			local boltTile = myTile.getNextTile(dir);
			if (this.Math.abs(boltTile.Level - myTile.Level) <= this.m.MaxLevelDifference)
			{
				xztile.push(boltTile);
				xztile.push(boltTile);
			}
		}
		local left = dir - 1 < 0 ? 5 : dir - 1;
		if (myTile.hasNextTile(left))
		{
			local boltTile = myTile.getNextTile(left);
			if (this.Math.abs(boltTile.Level - myTile.Level) <= this.m.MaxLevelDifference)
			{
				xztile.push(boltTile);
				xztile.push(boltTile);
			}
		}
		local right = dir + 1 > 5 ? 0 : dir + 1;
		if (myTile.hasNextTile(right))
		{
			local boltTile = myTile.getNextTile(right);
			if (this.Math.abs(boltTile.Level - myTile.Level) <= this.m.MaxLevelDifference)
			{
				xztile.push(boltTile);
				xztile.push(boltTile);
			}
		}
		xztile.push(myTile);
		xztile.push(myTile);
		xztile.push(myTile);
		xztile.push(myTile);
		xztile.push(myTile);
		xztile.push(myTile);
		local xztileC = xztile;
		mainh.m.IsBloodied = true;
		this.m.Container.getActor().getSprite("arms_icon").setBrush("icon_xx_weapon_15_bloodied");
		for( local i = 0; i < xztile.len(); i = ++i )
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 0 + (i * 80), function ( _skill )
			{
				local effectT = xxtileE[this.Math.rand(0, xxtileE.len() - 1)];
				local startfireT  = xztileC.remove(this.Math.rand(0, xztileC.len() - 1));
				this.Sound.play("sounds/combat/strike_down_hit_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 1.1, this.getContainer().getActor().getPos());
				this.Tactical.spawnProjectileEffect("xxprojectile_05", startfireT, effectT, 0.7 + (this.Math.rand(0, 5) * 0.1), 1.2, this.m.IsProjectileRotated, flip);
				this.Tactical.spawnSpriteEffect("sparkleflare_1", this.createColor("#ccf1ff"), startfireT, 0, 10, 1.2, 0.2, -10, 200, 400);
				this.Tactical.spawnSpriteEffect("sparkleflare_1", this.createColor("#ccf1ff"), effectT, 0, 40, 1.5, 1.5, -10, 400, 300);
				this.Tactical.spawnSpriteEffect("sparkleflare_2", this.createColor("#ccf1ff"), effectT, 0, 40, 1, 0.5, 10, 150, 350);
			}.bindenv(this), this);
		}
		this.Time.scheduleEvent(this.TimeUnit.Virtual, xztile.len() * 80 + 150, function ( _skill )
		{
			if (xxattackOK == 1)
			{
				ttarget = xxtile[this.Math.rand(0, xxtile.len() - 1)];
				if (ttarget.isAlive())
				{
					_skill.attackEntity(_user, ttarget);
				}
				ttarget = xxtile[this.Math.rand(0, xxtile.len() - 1)];
				if (ttarget.isAlive())
				{
					_skill.attackEntity(_user, ttarget);
				}
				ttarget = xxtile[this.Math.rand(0, xxtile.len() - 1)];
				if (ttarget.isAlive())
				{
					_skill.attackEntity(_user, ttarget);
				}
				ttarget = xxtile[this.Math.rand(0, xxtile.len() - 1)];
				if (ttarget.isAlive())
				{
					_skill.attackEntity(_user, ttarget);
				}
				ttarget = xxtile[this.Math.rand(0, xxtile.len() - 1)];
				if (ttarget.isAlive())
				{
					_skill.attackEntity(_user, ttarget);
				}
			}
		}.bindenv(this), this);
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 5;
			_properties.HitChanceAdditionalWithEachTile += -1;
		}
	}

	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		for( local i = 0; i < 6; i = i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
			}
			i = ++i;
		}
	}

});

