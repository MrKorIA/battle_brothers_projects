this.cp_send_beast_roamers_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		// Public
		CooldownInBBSeconds = 200.0,	// roughly 2 days
		RoamDurationInBBSeconds = 150,	// roughly 1.5 days
	},
	function create()
	{
		this.m.ID = "cp_send_beast_roamers_action";
		this.m.Cooldown = 5.0;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (this.findApplicableSettlement(_faction) == null) return;

		this.m.Score = 10;
	}

	function onExecute( _faction )
	{
		local settlement = this.findApplicableSettlement(_faction);
		settlement.setLastSpawnTimeToNow();

		local roam = ::new("scripts/ai/world/orders/roam_order");
		roam.setNoTerrainAvailable();
		roam.setTime(this.m.RoamDurationInBBSeconds);	// These roamer exist only for two day
		roam.setAvoidHeat(true);
		roam.setMinRange(1);
		roam.setMaxRange(5);
		foreach (likeableTerrain in settlement.getLikeableTerrain())
		{
			roam.setTerrain(likeableTerrain, true);
		}

		local move = ::new("scripts/ai/world/orders/move_order");
		move.setDestination(settlement.getTile());

		local despawn = ::new("scripts/ai/world/orders/despawn_order");

		local resourceScale = 0.5;	// By default, we use half as many base resources as our origin-location has
		resourceScale *= this.getReputationToDifficultyLightMult();		// Then we apply a simple vanilla day-scaling. This scales faster, but not for as much as the location scaling
		local party = settlement.spawnScaledRoamingParty(resourceScale);
		local controller = party.getController();
		controller.addOrder(roam);
		controller.addOrder(move);
		controller.addOrder(despawn);
	}

// New Functions
	function findApplicableSettlement( _faction )
	{
		local settlements = [];
		foreach (s in _faction.getSettlements())
		{
			if (!s.m.CP_CanSpawnRoamer) continue;
			if (s.getRoamerSpawnList() == null) continue;
			if (s.getLastSpawnTime() + this.m.CooldownInBBSeconds > ::Time.getVirtualTimeF()) continue;

			settlements.push({
				D = s,
				P = 10
			});
		}
		if (settlements.len() == 0) return null;

		return this.pickWeightedRandom(settlements);
	}
});

