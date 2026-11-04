this.ai_punch_swing <- this.inherit("scripts/skills/skill", {
	m = {	
		StunTime = 1,
		StunChance = 35,
	},
	function setStunTime( _d )
	{
		this.m.StunTime = _d;
	}

	function setStunChance( _d )
	{
		this.m.StunChance = _d;
	}

	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Широкий удар";
		this.m.Overlay = "active_06";
		this.m.SoundOnUse = [
			"sounds/combat/shatter_01.wav",
			"sounds/combat/shatter_02.wav",
			"sounds/combat/shatter_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/unhold_swipe_hit_01.wav",
			"sounds/enemies/unhold_swipe_hit_02.wav",
			"sounds/enemies/unhold_swipe_hit_04.wav",
			"sounds/enemies/unhold_swipe_hit_05.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 20;
		this.m.ChanceDisembowel = 1;
		this.m.ChanceSmash = 60;
	}

	function onUse( _user, _targetTile )
	{
		local ret = false;
		local ownTile = this.m.Container.getActor().getTile();
		local soundBackup = [];
		this.spawnAttackEffect(ownTile, this.Const.Tactical.AttackEffectThresh);
		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() != _user.getID())
		{
			return this.attackEntity(_user, _targetTile.getEntity());
		}
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
					ret = this.attackEntity(_user, tile.getEntity()) || ret;
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
		return ret;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			if (this.Math.rand(1, 100) <= this.m.StunChance && !_targetEntity.getCurrentProperties().IsImmuneToStun)
			{
				if (_targetEntity.getSkills().hasSkill("effects.stunned"))
				{
					_targetEntity.getSkills().removeByID("effects.stunned");
				}
				local stun = this.new("scripts/skills/effects/stunned_effect");
				local stm = this.Math.rand(1, this.m.StunTime);
				_targetEntity.getSkills().add(stun);
				stun.setTurns(stm);
				if (!_targetEntity.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " was stunned for " + stm + " turn.");
				}
			}
		}
	}

});

