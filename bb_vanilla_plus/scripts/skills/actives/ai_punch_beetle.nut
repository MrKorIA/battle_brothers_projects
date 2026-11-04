this.ai_punch_beetle <- this.inherit("scripts/skills/skill", {
	m = {	},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Cross Slice";
		this.m.Overlay = "active_06";
		this.m.SoundOnUse = [
			"sounds/combat/swing_01.wav",
			"sounds/combat/swing_02.wav",
			"sounds/combat/swing_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/swing_hit_01.wav",
			"sounds/combat/swing_hit_02.wav",
			"sounds/combat/swing_hit_03.wav"
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
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 99;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 0;
		this.m.MaxLevelDifference = 1;
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
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
		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() != _user.getID())
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
			return this.attackEntity(_user, _targetTile.getEntity());
		}
		local ownTile = this.m.Container.getActor().getTile();
		local ret = false;
		local soundBackup = [];
		local targets = this.getAffectedTiles(_targetTile);
		foreach( t in targets )
		{
			this.spawnAttackEffect(t, this.Const.Tactical.AttackEffectSlash);
			this.spawnAttackEffect(t, this.Const.Tactical.AttackEffectChop);
			if (t.IsOccupiedByActor && t.getEntity().isAttackable() && !t.getEntity().isAlliedWith(_user) && this.Math.abs(t.Level - ownTile.Level) <= 1)
			{
				if (ret && soundBackup.len() == 0)
				{
					soundBackup = this.m.SoundOnHit;
					this.m.SoundOnHit = [];
				}
				ret = this.attackEntity(_user, t.getEntity()) || ret;
				if (!_user.isAlive() || _user.isDying())
				{
					break;
				}
			}
		}
		if (ret && this.m.SoundOnHit.len() == 0)
		{
			this.m.SoundOnHit = soundBackup;
		}
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 80;
			_properties.DamageRegularMax = 100;
		}
	}

});

