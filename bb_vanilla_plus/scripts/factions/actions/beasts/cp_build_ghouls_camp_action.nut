this.cp_build_ghouls_camp_action <- this.inherit("scripts/factions/actions/cp_build_beast_camp_action", {
	m = {},
	function create()
	{
		this.m.ID = "cp_build_ghouls_camp_action";
		this.cp_build_beast_camp_action.create();

		this.m.DefenderSpawnlistId = "Ghouls";
		this.m.CampLimitDefault = 3;
		this.m.CampScriptName = "scripts/entity/world/locations/cp_beast_locations/cp_beast_ghoul_location";
	}

// New Overrides
	function findTileToSpawn()
	{
		local minDistToSettlements = 7;
		local maxDistToSettlements = 1000;
		local minDistToEnemyLocations = 4;
		local minDistToAlliedLocations = 4;
		local minY = 0.25;	// Neither in the desert
		local maxY = 0.75;	// Nor in the snow

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
		{
			// Ghouls only live in Swamps. This makes they hideouts very rare to spawn because swamps are so rare and the RNG generator needs to hit a swamp tile randomly
			if (i == ::Const.World.TerrainType.Swamp)
			{
				continue;
			}

			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowedTerrain, minDistToSettlements, maxDistToSettlements, 1000, minDistToEnemyLocations, minDistToAlliedLocations, null, minY, maxY);

		return tile;
	}
});

