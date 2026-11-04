this.wang01_02 <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.wang01_02";
		this.m.Name = "Боевой клич";
		this.m.Description = "";
		this.m.Icon = "skills/active_24.png";
		this.m.IconDisabled = "skills/active_24.png";
		this.m.Overlay = "active_24";
		this.m.SoundOnUse = [
			"sounds/combat/rage_01.wav",
			"sounds/combat/rage_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 1;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " издает боевой клич");
		}

		local tag = {
			User = _user
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1000, this.onDelayedEffect, tag);
		this.m.IsSpent = true;
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local mytile = _tag.User.getTile();
		local actors = this.Tactical.Entities.getAllInstances();

		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (a.getID() == _tag.User.getID())
				{
					continue;
				}

				if (a.getFaction() == _tag.User.getFaction())
				{
					local difficulty = 10 - this.Math.pow(a.getTile().getDistanceTo(mytile), this.Const.Morale.EnemyKilledDistancePow);

					if (a.getMoraleState() == this.Const.MoraleState.Fleeing)
					{
						a.checkMorale(this.Const.MoraleState.Wavering - this.Const.MoraleState.Fleeing, difficulty);
					}
					else
					{
						a.checkMorale(1, difficulty);
					}

					a.setFatigue(a.getFatigue() - 20);
				}
				else if (!a.isAlliedWith(_tag.User))
				{
					local difficulty = 5 + this.Math.pow(a.getTile().getDistanceTo(mytile), this.Const.Morale.AllyKilledDistancePow);
					a.checkMorale(-1, difficulty, this.Const.MoraleCheckType.MentalAttack);
				}
			}
		}
	}

});

