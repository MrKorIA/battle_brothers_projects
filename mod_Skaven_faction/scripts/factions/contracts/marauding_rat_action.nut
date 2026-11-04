this.marauding_rat_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Origin = null
	},
	function create()
	{
		this.m.ID = "marauding_rat_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 14;
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

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.Math.rand(1, 100) > 10)
		{
			return;
		}

		local settlements = _faction.getSettlements();
		local rat = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getSettlements();
		local lowestDistance = 9999;
		local origin;

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.isIsolated() || !s.isDiscovered())
			{
				continue;
			}

			foreach( b in rat )
			{
				local d = s.getTile().getDistanceTo(b.getTile());

				if (d <= 35 && d < lowestDistance)
				{
					lowestDistance = d;
					origin = s;
				}
			}
		}

		if (origin == null)
		{
			return;
		}

		this.m.Origin = origin;
		this.m.Score = 1;
	}

	function onClear()
	{
		this.m.Origin = null;
	}

	function onExecute( _faction )
	{
		local contract = this.new("scripts/contracts/contracts/marauding_rat_contract");
		contract.setFaction(_faction.getID());
		contract.setEmployerID(_faction.getRandomCharacter().getID());
		contract.setOrigin(this.m.Origin);
		this.World.Contracts.addContract(contract);
	}

});

