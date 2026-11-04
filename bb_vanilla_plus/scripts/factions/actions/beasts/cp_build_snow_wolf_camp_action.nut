this.cp_build_snow_wolf_camp_action <- this.inherit("scripts/factions/actions/cp_build_beast_camp_action", {
	m = {},
	function create()
	{
		this.m.ID = "cp_build_snow_wolf_camp_action";
		this.cp_build_beast_camp_action.create();

		this.m.DefenderSpawnlistId = "XXMobWhiteWolf";
		this.m.CampLimitDefault = 3;
		this.m.CampScriptName = "scripts/entity/world/locations/cp_beast_locations/cp_beast_snow_wolf_location";
	}

// New Overrides
	function findTileToSpawn()
	{
		local minDistToSettlements = 7;
		local maxDistToSettlements = 1000;
		local minDistToEnemyLocations = 4;
		local minDistToAlliedLocations = 4;
		local minY = 0.75;
		local maxY = 1.0;

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
		{
			if (i == ::Const.World.TerrainType.SnowyForest || i == ::Const.World.TerrainType.Snow || i == ::Const.World.TerrainType.Tundra)
			{
				continue;
			}

			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowedTerrain, minDistToSettlements, maxDistToSettlements, 1000, minDistToEnemyLocations, minDistToAlliedLocations, null, minY, maxY);

		return tile;
	}
});

