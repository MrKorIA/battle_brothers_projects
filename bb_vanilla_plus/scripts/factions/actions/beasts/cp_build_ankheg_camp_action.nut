this.cp_build_ankheg_camp_action <- this.inherit("scripts/factions/actions/cp_build_beast_camp_action", {
	m = {},
	function create()
	{
		this.m.ID = "cp_build_ankheg_camp_action";
		this.cp_build_beast_camp_action.create();

		this.m.DefenderSpawnlistId = "XXMobAnkheg";
		this.m.CampLimitDefault = 2;
		this.m.CampScriptName = "scripts/entity/world/locations/cp_beast_locations/cp_beast_ankheg_location";
		this.m.DayThresholdMin = ::VanillaPlus.Const.DayThresholdMinDangerBeasts;
	}

// New Overrides
	function findTileToSpawn()
	{
		local minDistToSettlements = 10;
		local maxDistToSettlements = 1000;
		local minDistToEnemyLocations = 4;
		local minDistToAlliedLocations = 4;
		local minY = 0.0;
		local maxY = 0.5;	// Only in the lower half of the map

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
		{
			if (i == ::Const.World.TerrainType.Desert || i == ::Const.World.TerrainType.Steppe)
			{
				continue;
			}

			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowedTerrain, minDistToSettlements, maxDistToSettlements, 1000, minDistToEnemyLocations, minDistToAlliedLocations, null, minY, maxY);

		return tile;
	}
});

