this.sb_chokentoss_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3,
		Skillcool = 3,
		TossTarget = null
	},
	function create()
	{
		this.m.ID = "actives.sb_chokentoss_skill";
		this.m.Name = "12. Грубый бросок (Установить цель)";
		this.m.Description = "Выберите цель для броска. Вероятность успеха всегда составляет 77%. Если цель выбрана неудачно, навык броска не может быть использован.";
		this.m.Icon = "ui/xx45.png";
		this.m.IconDisabled = "ui/xx45_sw.png";
		this.m.Overlay = "perk_38_active";
		this.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/thresh_hit_01.wav",
			"sounds/combat/thresh_hit_02.wav",
			"sounds/combat/thresh_hit_03.wav"
		];
		this.m.SoundVolume = 1.5;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		if (this.m.TossTarget == null)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Cooldown : 3 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
			});
		}
		else
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of " + this.getMaxRange() + " tiles (After Level 10 : Increased Max Range)"
			});
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Base Damage 30~150 (150% damage to armor, Max damage increases with the number of Takedown skills)"
			});
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]WARNING:[/color] This skill is removed at the end of the turn or when waiting."
			});
		}
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (this.m.TossTarget == null)
		{
			if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}
			if (_targetTile.IsEmpty)
			{
				return false;
			}
			local target = _targetTile.getEntity();
			if (target == null)
			{
				return false;
			}
			if (target.getCurrentProperties().IsRooted)
			{
				return false;
			}
			if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
			{
				return false;
			}
			if (target.isAlliedWith(this.getContainer().getActor()))
			{
				return false;
			}
			return true;
		}
		else
		{
			if (!_targetTile.IsEmpty)
			{
				return false;
			}
			return true;
		}
	}

	function clearTossTarget()
	{
		if (this.m.TossTarget != null)
		{
			local target = this.m.TossTarget;
			if (target.hasSprite("permanent_injury_toss1"))
			{
				target.getSprite("permanent_injury_toss1").Visible = false;
				target.removeSprite("permanent_injury_toss1");
			}
		}
		this.m.Icon = "ui/xx45.png";
		this.m.TossTarget = null;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.TossTarget == null)
		{
			this.m.Skillcool = 0;
			local target = _targetTile.getEntity();
			this.Tactical.getShaker().shake(target, _user.getTile(), 4);
			if (this.Math.rand(1, 99) > 77)
			{
				local overwhelm = this.getContainer().getSkillByID("perk.overwhelm");
				if (overwhelm != null)
				{
					overwhelm.onTargetMissed(this, target);
				}
				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " on " + this.Const.UI.getColorizedEntityName(target) + ", but misses");
				}
				return false;
			}
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " on " + this.Const.UI.getColorizedEntityName(target));
			}
			this.m.Icon = "ui/xx45b.png";
			this.m.TossTarget = target;
			if (target.hasSprite("permanent_injury_toss1"))
			{
				target.getSprite("permanent_injury_toss1").Visible = false;
				target.removeSprite("permanent_injury_toss1");
			}
			target.addSprite("permanent_injury_toss1").setBrush("bust_arrow");
			target.getSprite("permanent_injury_toss1").Visible = true;
			target.getSprite("permanent_injury_toss1").Scale = 0.9;
			target.getSprite("permanent_injury_toss1").Color = this.createColor("#ff6a19");
			target.setSpriteOffset("permanent_injury_toss1", this.createVec(30, 15));
			target.getSprite("permanent_injury_toss1").Rotation = -45.0;
			this.m.IsTargetingActor = false;
			this.m.IsVisibleTileNeeded = false;
			this.m.ActionPointCost = 0;
			this.m.FatigueCost = 0;
			this.m.MinRange = 1;
			this.m.MaxRange = 2 + (this.getContainer().getActor().getLevel() >= 10 ? 2 : 0);
			return true;
		}
		local target = this.m.TossTarget;
		this.clearTossTarget();
		if (target == null || !target.isAlive() || !target.isAttackable())
		{
			return false;
		}
		if (!_targetTile.IsEmpty)
		{
			return false;
		}
		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " threw " + this.Const.UI.getColorizedEntityName(target));
		}

		local overwhelm = this.getContainer().getSkillByID("perk.overwhelm");
		if (overwhelm != null)
		{
			overwhelm.onTargetHit(this, target, this.Const.BodyPart.Body, 0, 0);
		}
		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		this.applyFatigueDamage(target, 5);
		local rr = this.TakedownNum(_user);
		local damage = this.Math.rand(30, 100 + (rr * 50));
		local tag = {
			Attacker = _user,
			Skill = this,
			HitInfo = clone this.Const.Tactical.HitInfo
		};
		tag.HitInfo.DamageRegular = damage;
		tag.HitInfo.DamageArmor = damage * 1.5;
		tag.HitInfo.DamageFatigue = 5;
		tag.HitInfo.DamageDirect = 0.4;
		tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
		tag.HitInfo.BodyDamageMult = 1.0;
		tag.HitInfo.FatalityChanceMult = 0.0;
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		this.spawnAttackEffect(_user.getTile(), this.Const.Tactical.AttackEffectThresh2);
		this.Tactical.getNavigator().teleport(target, _targetTile, this.onKnockedDown, tag, true);
		return true;
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.Attacker.isAlive() && _entity.isAlive() && _entity.isAttackable())
		{
			if (_tag.Skill.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
			}
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap())
		{
			return false;
		}
		if (!this.skill.isUsable())
		{
			return false;
		}
		if (this.m.TossTarget == null)
		{
			if (this.m.Skillcool < this.m.Cooldown)
			{
				return false;
			}

			return true;
		}
		local target = this.m.TossTarget;
		if (!target.isAlive() || !target.isAttackable())
		{
			this.clearTossTarget();
			return false;
		}
		if (actor.getTile().getDistanceTo(target.getTile()) > 1)
		{
			this.clearTossTarget();
			return false;
		}
		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
		if (this.m.TossTarget != null)
		{
			local actor = this.getContainer().getActor();
			local target = this.m.TossTarget;
			if (!target.isAlive() || !target.isAttackable() || actor.getTile().getDistanceTo(target.getTile()) > 1)
			{
				this.clearTossTarget();
			}
		}
	}

	function onWaitTurn()
	{
		if (this.m.TossTarget != null)
		{
			this.clearTossTarget();
		}
	}

	function onCombatFinished()
	{
		this.clearTossTarget();
		this.m.Skillcool = this.m.Cooldown;
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.TossTarget != null)
		{
			this.m.MaxRange = 2 + (this.getContainer().getActor().getLevel() >= 10 ? 2 : 0);
		}
		else
		{
			this.m.MaxRange = 1;
		}
	}

});

