this.rat_warpfire_throw_skill <- this.inherit("scripts/skills/skill", {
	m = {
		AdditionalAccuracy = 0,
		AdditionalHitChance = 0,
		SoundOnFire = [],
		WasFiredThisTurn = false
	},
	function onItemSet()
	{
		this.m.MaxRange = this.m.Item.getRangeMax();
	}

	function create()
	{
		this.m.ID = "actives.rat_warpfire_throw";
		this.m.Name = "Выстрелить из метателя Варп-Огня";
		this.m.Description = "Обрушить на врага струю концентрированного Варп-Огня. Может поразить несколько целей за один выстрел, но чем дальше они находятся, тем меньше шанс попадания. Поражённые цели заражаются чумой, а на пустых клетках может остаться горящий варп-огонь. Нельзя использовать, пока персонаж вовлечён в ближний бой.";
		this.m.Icon = "skills/active_203.png";
		this.m.IconDisabled = "skills/active_203_sw.png";
		this.m.Overlay = "rat_warpfire_throw";
		this.m.SoundOnFire = [
			"sounds/combat/dlc6/fire_lance_01.wav",
			"sounds/combat/dlc6/fire_lance_02.wav",
			"sounds/combat/dlc6/fire_lance_03.wav",
			"sounds/combat/dlc6/fire_lance_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/fire_gonne_hit_01.wav",
			"sounds/combat/dlc6/fire_gonne_hit_02.wav",
			"sounds/combat/dlc6/fire_gonne_hit_03.wav",
			"sounds/combat/dlc6/fire_gonne_hit_04.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 750;
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
		this.m.InjuriesOnBody = this.Const.Injury.Burning;
		this.m.InjuriesOnHead = this.Const.Injury.Burning;
		this.m.DirectDamageMult = 0.25;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 20;
		this.m.MinRange = 2;
		this.m.MaxRange = 2;
		this.m.MaxRangeBonus = 1;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может задеть до 6 целей"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток на равнине и [color=" + this.Const.UI.Color.PositiveValue + "]" + (this.getMaxRange() + this.m.MaxRangeBonus) + "[/color] клеток при стрельбе с возвышенности."
		});

		if (10 + this.m.AdditionalAccuracy >= 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (10 + this.m.AdditionalAccuracy) + "%[/color] к шансу на попадание и [color=" + this.Const.UI.Color.NegativeValue + "]" + (-10 + this.m.AdditionalHitChance) + "%[/color] за каждую клетку до цели. Шанс попадания не зависит от объектов или персонажей на линии огня."
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (10 + this.m.AdditionalAccuracy) + "%[/color] к шансу на попадание и [color=" + this.Const.UI.Color.NegativeValue + "]" + (-10 + this.m.AdditionalHitChance) + "%[/color] за каждую клетку до цели. Шанс попадания не зависит от объектов или персонажей на линии огня."
			});
		}

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Поражённые цели заражаются чумой, наносящей дополнительно [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] чумного урона за ход, в течение 6 ходов"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "На пустых поражённых клетках с шансом [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color] остаётся варп-огонь"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/tooltips/warning.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Каждый выстрел нагревает огнемёт: складывающийся шанс взрыва на 30%. Простой остывает огнемёт на 30%[/color]"
		});

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Нельзя использовать, пока персонаж вовлечён в ближний бой[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getContainer().getActor().getFlags().has("rat") && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
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

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 10 + this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile += -10 + this.m.AdditionalHitChance;
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

	function onUse( _user, _targetTile )
	{
		this.Sound.play(this.m.SoundOnFire[this.Math.rand(0, this.m.SoundOnFire.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _user.getPos());
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);

		local item = this.getItem();

		if (this.Math.rand(1, 100) <= item.getHeat())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, this.onOverheatExplosion.bindenv(this), {
				User = _user
			});
		}

		item.addHeat(item.m.HeatPerShot);
		this.m.WasFiredThisTurn = true;
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local targetTile = _tag.TargetTile;
		local affectedTiles = this.getAffectedTiles(targetTile);
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, user.getPos());

		foreach( t in affectedTiles )
		{
			for (local i = 0; i < this.Const.Tactical.WarpFireParticles.len(); i = ++i)
			{
				local effect = this.Const.Tactical.WarpFireParticles[i];
				this.Tactical.spawnParticleEffect(false, effect.Brushes, t, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 5));
			}
		}

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
			if (!t.IsOccupiedByActor)
			{
				if (this.Math.rand(1, 100) <= 30)
				{
					this.spawnWarpFireOnTile(t, user.isPlayerControlled());
				}

				continue;
			}

			if (!t.getEntity().isAttackable())
			{
				continue;
			}

			local target = t.getEntity();
			local success = this.attackEntity(user, target, false);

			if (success && target.isAlive() && !target.isDying() && !target.getFlags().has("rat") && !target.getCurrentProperties().IsImmuneToPlague)
			{
				target.getSkills().add(this.new("scripts/skills/effects/rat_plague_effect"));
			}
		}
	}

	function spawnWarpFireOnTile( _tile, _playerApplied )
	{
		local subtypesToCheck = this.Tactical.Entities.getNonFlammableTileSubtypes();

		if (_tile.Type == this.Const.Tactical.TerrainType.ShallowWater || _tile.Type == this.Const.Tactical.TerrainType.DeepWater || subtypesToCheck.find(_tile.Subtype) != null)
		{
			return;
		}

		local fire_effect = {
			Type = "warpfire",
			Tooltip = "Варп-огонь бушует здесь, плавя доспехи и плоть",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = _playerApplied,
			Timeout = this.Time.getRound() + this.Const.Combat.FireTimeout * 2,
			Callback = this.Const.Tactical.Common.onApplyWarpFire,
			function Applicable( _a )
			{
				return true;
			}

		};
		local particles = [];

		for (local i = 0; i < this.Const.Tactical.WarpFireParticles.len(); i = ++i)
		{
			particles.push({
				Entity = true,
				Brushes = this.Const.Tactical.WarpFireParticles[i].Brushes,
				Tile = _tile,
				Delay = this.Const.Tactical.WarpFireParticles[i].Delay,
				Quantity = this.Const.Tactical.WarpFireParticles[i].Quantity,
				Lifetime = this.Const.Tactical.WarpFireParticles[i].LifeTimeQuantity,
				Rate = this.Const.Tactical.WarpFireParticles[i].SpawnRate,
				Stages = this.Const.Tactical.WarpFireParticles[i].Stages
			});
		}

		this.Tactical.State.spawnEffectOnTile(_tile, "warpfire", fire_effect, particles);
		_tile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
		_tile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
	}

	function onOverheatExplosion( _tag )
	{
		this.Const.Tactical.Common.spawnWarpExplosion(_tag.User.getTile(), 50);
	}

	function onTurnEnd()
	{
		if (!this.m.WasFiredThisTurn && this.getItem() != null)
		{
			this.getItem().coolDown(this.getItem().m.CooldownPerTurn);
		}

		this.m.WasFiredThisTurn = false;
	}

	function onCombatFinished()
	{
		this.m.WasFiredThisTurn = false;
	}

});
