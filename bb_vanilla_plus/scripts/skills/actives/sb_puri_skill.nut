this.sb_puri_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 5,
		Skillcool = 5
	},
	function create()
	{
		this.m.ID = "actives.sb_puri_skill";
		this.m.Name = "Очищающее пламя";
		this.m.Description = "Накладывает заклинание, которое истребляет нежить в большой области перед вами. Влияет только на вражеских нежить.";
		this.m.Icon = "ui/xx47.png";
		this.m.IconDisabled = "ui/xx47_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
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
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsTargetingActor = false;
		this.m.IsAOE = true;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 35;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Снижает защиты ближнего и дальнего боя попавшей под воздействие заклинания нежити на 9"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "20-60 урона (шанс 65%)"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 5 ходов \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		return ret;
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		local left = dir - 1 < 0 ? 5 : dir - 1;
		local right = dir + 1 > 5 ? 0 : dir + 1;

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}

			if (forwardTile.hasNextTile(dir))
			{
				local FforwardTile = forwardTile.getNextTile(dir);
				if (this.Math.abs(FforwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(FforwardTile);
				}
			}

			left = dir - 1 < 0 ? 5 : dir - 1;
			if (forwardTile.hasNextTile(left))
			{
				local LforwardTile = forwardTile.getNextTile(left);
				if (this.Math.abs(LforwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(LforwardTile);
				}
			}

			right = dir + 1 > 5 ? 0 : dir + 1;
			if (forwardTile.hasNextTile(right))
			{
				local RforwardTile = forwardTile.getNextTile(right);
				if (this.Math.abs(RforwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(RforwardTile);
				}
			}
		}

		left = dir - 1 < 0 ? 5 : dir - 1;
		if (_targetTile.hasNextTile(left))
		{
			local forwardTile = _targetTile.getNextTile(left);
			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
			if (forwardTile.hasNextTile(left))
			{
				forwardTile = forwardTile.getNextTile(left);
				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
			}
		}
		if (ownTile.hasNextTile(left))
		{
			local forwardTile = ownTile.getNextTile(left);
			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
			if (forwardTile.hasNextTile(left))
			{
				forwardTile = forwardTile.getNextTile(left);
				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
			}
			if (forwardTile.hasNextTile(left))
			{
				forwardTile = forwardTile.getNextTile(left);
				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
			}
		}

		right = dir + 1 > 5 ? 0 : dir + 1;
		if (_targetTile.hasNextTile(right))
		{
			local forwardTile = _targetTile.getNextTile(right);
			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
			if (forwardTile.hasNextTile(right))
			{
				forwardTile = forwardTile.getNextTile(right);
				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
			}
		}
		if (ownTile.hasNextTile(right))
		{
			local forwardTile = ownTile.getNextTile(right);
			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
			if (forwardTile.hasNextTile(right))
			{
				forwardTile = forwardTile.getNextTile(right);
				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
			}
			if (forwardTile.hasNextTile(right))
			{
				forwardTile = forwardTile.getNextTile(right);
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
		this.m.Skillcool = 0;
		local user = _user;
		local targetTile = _targetTile;
		local myTile = user.getTile();
		local dir = myTile.getDirectionTo(targetTile);
		local targets = this.getAffectedTiles(targetTile);
		local effect = {
		Delay = 0,
		Quantity = 100,
		LifeTimeQuantity = 100,
		SpawnRate = 150,
		Brushes = [
			"effect_fire_01",
			"effect_fire_02",
			"effect_fire_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.1,
				ColorMin = this.createColor("6dd6edcc"),
				ColorMax = this.createColor("ace6f2ff"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				SpawnOffsetMin = this.createVec(-50, -30),
				SpawnOffsetMax = this.createVec(50, 20),
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(0, 80)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("b3f7ff40"),
				ColorMax = this.createColor("73f1ff80"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(0, 80)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("e3feffcc"),
				ColorMax = this.createColor("e3e6ffff"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(0, 80)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("00fff2ff"),
				ColorMax = this.createColor("73f5ee80"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(0, 80)
			}
		]
		};

		foreach( t in targets )
		{
			this.Tactical.spawnParticleEffect(false, effect.Brushes, t, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 5));

			if (!t.IsOccupiedByActor || !t.getEntity().isAttackable() || !t.getEntity().getFlags().has("undead") || t.getEntity().isAlliedWith(user))
			{
				continue;
			}

			local target = t.getEntity();
			target.getBaseProperties().MeleeDefense -= 9;
			target.getBaseProperties().RangedDefense -= 9;
			local fakeb = this.new("scripts/skills/actives/ai_fakebuff");
			fakeb.m.Overlay = "";
			target.getSkills().add(fakeb);

			if (this.Math.rand(1, 99) <= 65)
			{
				this.attackEntity(user, target, false);
			}
			else
			{
				this.Tactical.getShaker().shake(target, user.getTile(), 4);
			}
		}
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 20;
			_properties.DamageRegularMax = 60;
			_properties.RangedAttackBlockedChanceMult *= 0;
			_properties.DamageArmorMult *= 0;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
			_properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
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

