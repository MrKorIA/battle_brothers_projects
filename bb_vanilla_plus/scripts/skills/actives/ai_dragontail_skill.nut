this.ai_dragontail_skill <- this.inherit("scripts/skills/skill", {
	m = {
		TilesUsed = []
	},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Удар хвостом дракона";
		this.m.Description = "";
		this.m.KilledString = "Crushed";
		this.m.Icon = "skills/active_108.png";
		this.m.IconDisabled = "skills/active_108.png";
		this.m.Overlay = "active_108";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_tail_slam_01.wav",
			"sounds/enemies/lindwurm_tail_slam_02.wav",
			"sounds/enemies/lindwurm_tail_slam_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/lindwurm_tail_slam_hit_01.wav",
			"sounds/enemies/lindwurm_tail_slam_02.wav",
			"sounds/enemies/lindwurm_tail_slam_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		return null;
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
		}
		if (!_target.getCurrentProperties().IsImmuneToStun && !_target.getCurrentProperties().IsStunned)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
		}
		if (!_target.getCurrentProperties().IsImmuneToKnockBackAndGrab && !_target.getCurrentProperties().IsRooted)
		{
			local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

			if (knockToTile == null)
			{
				return;
			}

			this.m.TilesUsed.push(knockToTile.ID);

			local skills = _target.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");
			_target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
			local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage;

			if (damage == 0)
			{
				this.Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
			}
			else
			{
				local p = this.getContainer().getActor().getCurrentProperties();
				local tag = {
					Attacker = _user,
					Skill = this,
					HitInfo = clone this.Const.Tactical.HitInfo
				};
				tag.HitInfo.DamageRegular = damage;
				tag.HitInfo.DamageDirect = 1.0;
				tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
				tag.HitInfo.BodyDamageMult = 1.0;
				tag.HitInfo.FatalityChanceMult = 1.0;
				this.Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
			}
		}
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 80;
			_properties.DamageRegularMax += 100;
			_properties.DamageArmorMult *= 0.5;

			if (_targetEntity.getFlags().has("human"))
			{
				if (this.Math.rand(1, 100) <= 15)
				{
					_properties.MeleeSkill += 500;
				}
			}
			else
			{
				_properties.MeleeSkill += 500;
				_properties.DamageRegularMin += 700;
				_properties.DamageRegularMax += 700;
			}
		}
	}

	function onUse( _user, _targetTile )
	{
		local ret = false;
		local ownTile = this.m.Container.getActor().getTile();
		local soundBackup = [];
		this.m.TilesUsed = [];
		local gg = this.getContainer().getActor().getBaseProperties().MeleeSkill;
		if (gg >= 180)
		{
			for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, ownTile, this.Const.Tactical.MortarImpactParticles[i].Delay, this.Const.Tactical.MortarImpactParticles[i].Quantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].SpawnRate, this.Const.Tactical.MortarImpactParticles[i].Stages, this.createVec(0, -30));
			}
			local sounds = [
				"sounds/combat/poison_applied_01.wav",
				"sounds/combat/poison_applied_02.wav"
			];
			this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], 1.5, ownTile.Pos);
		}
		this.spawnAttackEffect(ownTile, this.Const.Tactical.AttackEffectThresh);

		for( local i = 5; i >= 0; i = --i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if (tile.IsOccupiedByActor && tile.getEntity().isAttackable() && this.Math.abs(tile.Level - ownTile.Level) <= 1 && !tile.getEntity().isAlliedWith(_user))
				{
					if (ret && soundBackup.len() == 0)
					{
						soundBackup = this.m.SoundOnHit;
						this.m.SoundOnHit = [];
					}

					local success = this.attackEntity(_user, tile.getEntity());

					if (success && !tile.IsEmpty && tile.getEntity().isAlive() && !tile.getEntity().isDying())
					{
						this.applyEffectToTarget(_user, tile.getEntity(), tile);
					}

					ret = success || ret;

					if (!_user.isAlive() || _user.isDying())
					{
						break;
					}
				}
			}
		}

		if (ret && this.m.SoundOnHit.len() == 0)
		{
			this.m.SoundOnHit = soundBackup;
		}

		this.m.TilesUsed = [];
		return ret;
	}

});

