this.cp_build_hexen_camp_action <- this.inherit("scripts/factions/actions/cp_build_beast_camp_action", {
	m = {},
	function create()
	{
		this.cp_build_beast_camp_action.create();
		this.m.ID = "cp_build_hexen_camp_action";

		this.m.DefenderSpawnlistId = "HexenAndMore";
		this.m.CampLimitDefault = 2;
		this.m.CampScriptName = "scripts/entity/world/locations/cp_beast_locations/cp_beast_hexe_location";
		this.m.DayThresholdMin = ::VanillaPlus.Const.DayThresholdMinDangerBeasts;
	}

// New Overrides
	function findTileToSpawn()
	{
		local minDistToSettlements = 7;
		local maxDistToSettlements = 25;
		local minDistToEnemyLocations = 5;
		local minDistToAlliedLocations = 5;
		local minY = 0.25;	// Neither in the desert
		local maxY = 0.75;	// Nor in the snow

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
		{
			// Hexen only live in Swamps or Forests.
			if (i == ::Const.World.TerrainType.Swamp || i == ::Const.World.TerrainType.Forest || i == ::Const.World.TerrainType.LeaveForest || i == ::Const.World.TerrainType.AutumnForest)
			{
				continue;
			}

			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowedTerrain, minDistToSettlements, maxDistToSettlements, 1000, minDistToEnemyLocations, minDistToAlliedLocations, null, minY, maxY);

		return tile;
	}
});

