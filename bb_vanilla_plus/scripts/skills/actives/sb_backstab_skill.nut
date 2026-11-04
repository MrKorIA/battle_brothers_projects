this.sb_backstab_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 1,
		Skillcool = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_backstab_skill";
		this.m.Name = "3. Удар в спину";
		this.m.Description = "Зайдите за цель и атакуйте её голову и шлем. Этот навык всегда попадает в голову. Шлему наносится больший урон. (Melee Skill)\n[color=#8f1e1e]Требования:[/color] Кинжал";
		this.m.Icon = "ui/xx61.png";
		this.m.IconDisabled = "ui/xx61_sw.png";
		this.m.Overlay = "active_rand";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_takeoff_01.wav",
			"sounds/enemies/vampire_takeoff_02.wav",
			"sounds/enemies/vampire_takeoff_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/impale_hit_01.wav",
			"sounds/combat/impale_hit_02.wav",
			"sounds/combat/impale_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 750;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=#135213]+25%[/color] бонусный урон брони за раунд (максимум 10 раундов)"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Если у цели есть дебафф \'Перегруженность\', она оглушается."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cooldown: 1 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInDaggers)
		{
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local target = _targetTile.getEntity();
		local effect = {
		Delay = 0,
		Quantity = 70,
		LifeTimeQuantity = 70,
		SpawnRate = 150,
		Brushes = [
			"effect_fire_01",
			"effect_fire_02",
			"effect_fire_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.3,
				LifeTimeMax = 0.4,
				ColorMin = this.createColor("00000000"),
				ColorMax = this.createColor("031c0200"),
				ScaleMin = 0.25,
				ScaleMax = 0.5,
				RotationMin = -20,
				RotationMax = 20,
				VelocityMin = 70,
				VelocityMax = 100,
				DirectionMin = this.createVec(-0.5, -0.2),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-25, -30),
				SpawnOffsetMax = this.createVec(25, 30)
			},
			{
				LifeTimeMin = 0.3,
				LifeTimeMax = 0.6,
				ColorMin = this.createColor("000000ff"),
				ColorMax = this.createColor("031c02ff"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = -20,
				RotationMax = 20,
				VelocityMin = 0,
				VelocityMax = 0,
				ForceMin = this.createVec(50, 70),
				ForceMax = this.createVec(100, 100)
			},
			{
				LifeTimeMin = 0.3,
				LifeTimeMax = 0.6,
				ColorMin = this.createColor("00000000"),
				ColorMax = this.createColor("031c0200"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				RotationMin = -20,
				RotationMax = 20,
				VelocityMin = 0,
				VelocityMax = 0,
				ForceMin = this.createVec(-100, 70),
				ForceMax = this.createVec(-150, 100)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("00000000"),
				ColorMax = this.createColor("031c0200"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = -20,
				RotationMax = 20,
				VelocityMin = 0,
				VelocityMax = 0,
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(50, 80)
			}
		]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _user.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 5));
		for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _user.getTile(), this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
		}

		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);
		if (knockToTile == null)
		{
			return false;
		}

		local tag = {
			Attacker = _user,
			Target = target,
			TTile = _targetTile,
			Skill = this
		};
		_user.setCurrentMovementType(this.Const.Tactical.MovementType.Default);
		_user.storeSpriteColors();
		_user.fadeTo(this.createColor("00000000"), 0);
		this.Tactical.getNavigator().teleport(_user, knockToTile, this.onKnockedDown, tag, true, 19);
		return true;
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.Attacker.isAlive() && !_tag.Attacker.isDying())
		{
			_tag.Attacker.fadeToStoredColors(700);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, function ( _skill )
			{
				if (_tag.Attacker.isAlive() && !_tag.Attacker.isDying() && _tag.Target.isAlive() && !_tag.Target.isDying() && _tag.Target.isAttackable())
				{
					if (_tag.Target.getSkills().hasSkill("effects.overwhelmed") && !_tag.Target.getCurrentProperties().IsImmuneToStun && !_tag.Target.getSkills().hasSkill("effects.stunned"))
					{
						_tag.Target.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
					}
					_tag.Attacker.restoreSpriteColors();
					_tag.Skill.spawnAttackEffect(_tag.TTile, this.Const.Tactical.AttackEffectSlash);
					_tag.Skill.attackEntity(_tag.Attacker, _tag.Target, false)
				}
			}.bindenv(this), this);
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this && this.getContainer().getActor().isPlacedOnMap())
		{
			local r = this.Time.getRound() * 0.25;
			if (this.Time.getRound() >= 10)
			{
				r = 2.5;
			}
			_properties.DamageArmorMult *= 1 + r;
			_properties.HitChance[this.Const.BodyPart.Head] += 100.0;
		}
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		return null;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (this.findTileToKnockBackTo(_originTile, _targetTile) == null)
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}
		else if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			return false;
		}
		else if (this.getContainer().hasSkill("actives.stab"))
		{
			return true;
		}
		else if (this.getContainer().hasSkill("actives.puncture"))
		{
			return true;
		}
		else if (this.getContainer().hasSkill("actives.deathblow"))
		{
			return true;
		}

		return false;
	}

	function isHidden()
	{
		if (this.getContainer().getActor().isPlacedOnMap())
		{
			local actorsk = this.getContainer().getActor().getSkills();
			if (!actorsk.hasSkill("actives.stab") && !actorsk.hasSkill("actives.puncture") && !actorsk.hasSkill("actives.deathblow"))
			{
				return true;
			}
			return false;
		}
		return false;
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

