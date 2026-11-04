this.ai_punch_hybrid <- this.inherit("scripts/skills/skill", {
	//used demon9
	m = {
		FireName = "bust_horror",
		FireScale = 1.1
	},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Attack";
		this.m.SoundOnUse = [
			"sounds/combat/overhead_strike_01.wav"
		];
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
		this.m.IsRanged = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
		this.m.ChanceSmash = 5;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileTimeScale = 0.9;
		this.setFireName(this.m.FireName, this.m.FireScale);
	}

	function setFireName( _n, _c )
	{
		this.m.FireName = _n;
		this.m.FireScale = _c;
		local mmid = -1;
		foreach(i, s in this.Const.ProjectileSprite)
		{
			if (s == this.m.FireName)
			{
				mmid = i;
				break;
			}
		}
		if (mmid == -1)
		{
			this.Const.ProjectileSprite.push(this.m.FireName);
			mmid = this.Const.ProjectileSprite.len() - 1;
			this.Const.ProjectileDecals.push([""]);
		}
		this.m.ProjectileType = mmid;
	}

	function onUpdate( _properties )
	{
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			this.m.MaxRange = 1;
		}
		else
		{
			this.m.MaxRange = this.m.ChanceSmash;
		}
	}

	function onUse( _user, _targetTile )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID())
		{
			if (_user.getTile().getDistanceTo(_targetTile) == 1)
			{
				this.m.IsRanged = false;
				this.spawnIcon("active_154", _user.getTile());
				this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
				return this.attackEntity(_user, _targetTile.getEntity());
			}
			else
			{
				this.m.IsRanged = true;
				local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
				if (_user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
				{
					this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, this.m.FireScale, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				}
				this.Sound.play("sounds/enemies/vampire_landing_01.wav", this.Const.Sound.Volume.Skill * 1.4, _targetTile.Pos);
				this.Sound.play("sounds/enemies/vampire_takeoff_01.wav", this.Const.Sound.Volume.Skill * 1.4, _targetTile.Pos);
				this.attackEntity(_user, _targetTile.getEntity(), false);
				this.m.IsRanged = false;
				return true;
			}
		}
		else
		{
			this.m.IsRanged = false;
			this.spawnIcon("active_154", _user.getTile());
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedAttackBlockedChanceMult *= 0;
			_properties.HitChanceAdditionalWithEachTile += -1;
		}
	}

});

