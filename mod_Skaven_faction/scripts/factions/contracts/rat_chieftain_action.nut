this.rat_chieftain_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "rat_chieftain_action";
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

		if (this.World.Assets.getBusinessReputation() < 1400)
		{
			return;
		}

		if (this.Math.rand(1, 100) > 10)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local settlements = _faction.getSettlements();
		local rat = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getSettlements();
		local lowestDistance = 9999;
		local lowestDistanceSettlement;

		foreach( s in settlements )
		{
			foreach( b in rat )
			{
				if (b.isLocationType(this.Const.World.LocationType.Unique))
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(b.getTile());

				if (d <= 25 && d < lowestDistance)
				{
					lowestDistance = d;
					lowestDistanceSettlement = s;
				}
			}
		}

		if (lowestDistanceSettlement == null)
		{
			return;
		}

		this.m.Score = 1;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local contract = this.new("scripts/contracts/contracts/rat_chieftain_contract");
		contract.setFaction(_faction.getID());
		contract.setEmployerID(_faction.getRandomCharacter().getID());
		this.World.Contracts.addContract(contract);
	}

});

