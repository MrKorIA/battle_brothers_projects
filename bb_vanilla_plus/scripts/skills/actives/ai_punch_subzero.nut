this.ai_punch_subzero <- this.inherit("scripts/skills/skill", {
	m = {
		SnowTiles = []
	},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Морозный взрыв";
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
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		for( local i = 1; i <= 3; i = ++i )
		{
			this.m.SnowTiles.push(this.MapGen.get("tactical.tile.snow" + i));
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

	function onUse( _user, _targetTile )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID())
		{
			if (_user.getTile().getDistanceTo(_targetTile) == 1 && this.Math.rand(1, 3) == 2)
			{
				this.m.IsRanged = false;
				this.spawnIcon("active_154", _user.getTile());
				this.Sound.play("sounds/combat/overhead_strike_01.wav", this.Const.Sound.Volume.Skill * 1.0, _targetTile.Pos);
				this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
				_targetTile.getEntity().getSkills().add(this.new("scripts/skills/effects/distracted_effect"));
				return this.attackEntity(_user, _targetTile.getEntity());
			}
			else
			{
				this.m.IsRanged = true;
				local tag = {
					Skill = this,
					User = _user,
					TargetTile = _targetTile
				};
				for( local i = 0; i < this.Const.Tactical.SpiritWalkStartParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SpiritWalkStartParticles[i].Brushes, _user.getTile(), this.Const.Tactical.SpiritWalkStartParticles[i].Delay, this.Const.Tactical.SpiritWalkStartParticles[i].Quantity, this.Const.Tactical.SpiritWalkStartParticles[i].LifeTimeQuantity, this.Const.Tactical.SpiritWalkStartParticles[i].SpawnRate, this.Const.Tactical.SpiritWalkStartParticles[i].Stages);
				}
				this.Sound.play("sounds/enemies/vampire_takeoff_01.wav", this.Const.Sound.Volume.Skill * 1.0, _targetTile.Pos);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
			}
		}
		else
		{
			this.m.IsRanged = false;
			this.spawnIcon("active_154", _user.getTile());
			this.Sound.play("sounds/combat/overhead_strike_01.wav", this.Const.Sound.Volume.Skill * 1.0, _targetTile.Pos);
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
			_targetTile.getEntity().getSkills().add(this.new("scripts/skills/effects/distracted_effect"));
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local targetTile = _tag.TargetTile;
		local myTile = user.getTile();
		local dir = myTile.getDirectionTo(targetTile);
		local targets = this.getAffectedTiles(targetTile);
		this.Sound.play("sounds/enemies/vampire_landing_01.wav", this.Const.Sound.Volume.Skill * 1.5, user.getPos());
		foreach( t in targets )
		{
			for( local i = 0; i < this.Const.Tactical.SpiritWalkEndParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SpiritWalkEndParticles[i].Brushes, t, this.Const.Tactical.SpiritWalkEndParticles[i].Delay, this.Const.Tactical.SpiritWalkEndParticles[i].Quantity, this.Const.Tactical.SpiritWalkEndParticles[i].LifeTimeQuantity, this.Const.Tactical.SpiritWalkEndParticles[i].SpawnRate, this.Const.Tactical.SpiritWalkEndParticles[i].Stages);
			}
			if (t.Subtype != this.Const.Tactical.TerrainSubtype.Snow && t.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow)
			{
				t.clear();
				t.Type = 0;
				_tag.Skill.m.SnowTiles[this.Math.rand(0, _tag.Skill.m.SnowTiles.len() - 1)].onFirstPass({
					X = t.SquareCoords.X,
					Y = t.SquareCoords.Y,
					W = 1,
					H = 1,
					IsEmpty = true,
					SpawnObjects = false
				});
			}
			if (t.IsOccupiedByActor && t.getEntity().isAttackable())
			{
				local e = t.getEntity();
				if (!e.isAlliedWith(_tag.User))
				{
					e.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
					this.attackEntity(_tag.User, e, false);
				}
			}
		}
		_tag.Skill.m.IsRanged = false;
		return true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			if (this.Math.rand(1, 4) == 2)
			{
				if (!_targetEntity.getCurrentProperties().IsImmuneToDaze)
				{
					_targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 40;
			_properties.DamageRegularMax = 80;
			_properties.DamageArmorMult = 0.9;
		}
	}

});

