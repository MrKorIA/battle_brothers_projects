this.cp_build_beast_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		// Public

		DayThresholdMin = 1,	// The world day clock must be at least on this for this camp to be able to spawn
		// Config
		CampLimitDefault = 1,	// This many camps can be present from Day 1
		DefenderSpawnlistId = "",	// Must be set by an inheriting class
		CampScriptName = "",
	},
	function create()
	{
		// this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local settlements = _faction.getSettlements();

		local foundCaves = 0;
		foreach (cave in settlements)
		{
			if (cave.getDefenderSpawnListId() == this.m.DefenderSpawnlistId)	// Cheap way to identify our related caves quickly
			{
				foundCaves++;
			}
		}
		if (foundCaves >= this.getCampLimit()) return;

		if (::World.getTime().Days < this.m.DayThresholdMin) return;

		this.m.Score = 2;
	}

	function onExecute( _faction )
	{
		local tile = this.findTileToSpawn();
		if (tile != null)
		{
			local camp = ::World.spawnLocation(this.m.CampScriptName, tile.Coords);
			if (camp != null)	// This creation might fail for some reason. Not sure though as it's in the exe
			{
				camp.setDefenderSpawnListId(this.m.DefenderSpawnlistId)
				camp.onSpawned();
				camp.setBanner("banner_beasts_01");
				_faction.addSettlement(camp, false);
				this.logInfo("addSettlement " + this.m.CampScriptName);
			}
		}
	}

// New Functions
	function getCampLimit()
	{
		return this.m.CampLimitDefault;
	}

	function findTileToSpawn()
	{
		local minDistToSettlements = 7;
		local maxDistToSettlements = 1000;
		local minDistToEnemyLocations = 5;
		local minDistToAlliedLocations = 10;	// So that all caves are more spread out
		local minY = 0.2;
		local maxY = 0.75;

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
			::Const.World.TerrainType.Mountains,
			::Const.World.TerrainType.Snow
		], minDistToSettlements, maxDistToSettlements, 1000, minDistToEnemyLocations, minDistToAlliedLocations, null, minY, maxY);

		return tile;
	}
});

