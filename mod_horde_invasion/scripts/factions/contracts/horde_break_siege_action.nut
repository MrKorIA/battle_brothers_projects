this.horde_break_siege_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Origin = null
	},
	function create()
	{
		this.m.ID = "horde_break_siege_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 7;
		this.m.IsStartingOnCooldown = false;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (!_faction.isReadyForContract())
		{
			return;
		}

		if (_faction.getPlayerRelation() <= 25)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 750)
		{
			return;
		}

		if (!this.World.FactionManager.isHordeInvasion())
		{
			return;
		}

		if (this.Math.rand(1, 100) > 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local settlements = _faction.getSettlements();
		local jin = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getSettlements();
		local mgl = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getSettlements();
		local lowest_distance = 9999;
		local best;

		foreach( s in settlements )
		{
			if (!s.isMilitary() || s.isIsolated() || !s.isDiscovered())
			{
				continue;
			}

			local numAttached = 0;

			foreach( l in s.getAttachedLocations() )
			{
				if (l.isActive() && l.isUsable())
				{
					numAttached = ++numAttached;
				}
			}

			if (numAttached < 2)
			{
				continue;
			}

			foreach( b in jin )
			{
				local d = s.getTile().getDistanceTo(b.getTile());

				if (d <= 25 && d < lowest_distance)
				{
					lowest_distance = d;
					best = s;
				}
			}

			foreach( b in mgl )
			{
				local d = s.getTile().getDistanceTo(b.getTile());

				if (d <= 25 && d < lowest_distance)
				{
					lowest_distance = d;
					best = s;
				}
			}
		}

		if (best == null)
		{
			return;
		}

		this.m.Origin = best;
		this.m.Score = 1;
	}

	function onClear()
	{
		this.m.Origin = null;
	}

	function onExecute( _faction )
	{
		local contract = this.new("scripts/contracts/contracts/horde_break_siege_contract");
		contract.setFaction(_faction.getID());
		contract.setEmployerID(_faction.getRandomCharacter().getID());
		contract.setOrigin(this.m.Origin);
		this.World.Contracts.addContract(contract);
	}

});
