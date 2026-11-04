this.ai_cosmictail_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Атака";
		this.m.SoundOnHit = [
			"sounds/combat/bash_hit_01.wav",
			"sounds/combat/bash_hit_02.wav",
			"sounds/combat/bash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 100;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileType = this.Const.ProjectileType.Javelin;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local ret = this.attackEntity(_user, target);
		local skillsound;
		if (_user.getTile().getDistanceTo(_targetTile) > 1)
		{
			skillsound = [
			"sounds/combat/bolt_shot_01.wav",
			"sounds/combat/bolt_shot_02.wav",
			"sounds/combat/bolt_shot_03.wav"
			];
			this.Sound.play(skillsound[this.Math.rand(0, skillsound.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
			this.spawnIcon("active_23", _user.getTile());
			if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _skill )
				{
					if (target.isAlive())
					{
						_skill.attackEntity(_user, target);
						this.Sound.play(skillsound[this.Math.rand(0, skillsound.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
					}
				}.bindenv(this), this);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, function ( _skill )
				{
					if (target.isAlive())
					{
						_skill.attackEntity(_user, target);
						this.Sound.play(skillsound[this.Math.rand(0, skillsound.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
					}
				}.bindenv(this), this);
				return true;
			}
			else
			{
				if (target.isAlive())
				{
					ret = this.attackEntity(_user, target) || ret;
				}
				if (target.isAlive())
				{
					ret = this.attackEntity(_user, target) || ret;
				}
				return ret;
			}
		}
		else
		{
			skillsound = [
			"sounds/combat/overhead_strike_01.wav",
			"sounds/combat/overhead_strike_02.wav",
			"sounds/combat/overhead_strike_03.wav"
			];
			this.Sound.play(skillsound[this.Math.rand(0, skillsound.len() - 1)], this.Const.Sound.Volume.Skill * 1.2, this.getContainer().getActor().getPos());
			this.spawnIcon("active_06", _user.getTile());
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
			return ret;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) > 1)
			{
				local mdef = this.Math.max(0, _targetEntity.getBaseProperties().getMeleeDefense());
				local rdef = this.Math.max(0, _targetEntity.getBaseProperties().getRangedDefense());
				_properties.MeleeSkill += this.Math.floor((mdef * 0.99) - rdef - 5);
				_properties.DamageArmorMult = 0.8;
			}
			else
			{
				_properties.DamageRegularMin += 50;
				_properties.DamageRegularMax += 50;
			}
		}
	}

});

