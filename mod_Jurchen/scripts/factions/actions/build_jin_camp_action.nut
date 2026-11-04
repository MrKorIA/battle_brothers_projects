this.build_jin_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_jin_camp_action";
		this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (this.World.getTime().Days < 70)
		{
		    return;
		}

		local settlements = _faction.getSettlements();

		if (this.World.FactionManager.isGreaterEvil())
		{
			if (settlements.len() > 3)
			{
				return;
			}
		}
		else if (settlements.len() > 5)
		{
			return;
		}

		this.m.Score = 2;
	}

	function onExecute( _faction )
	{
		local camp;
		local r = this.Math.rand(1, 100);
		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
		{
			if (i == ::Const.World.TerrainType.Land || i == ::Const.World.TerrainType.Steppe || i == ::Const.World.TerrainType.Badlands || i == ::Const.World.TerrainType.Desert)
			{
				continue;
			}

			disallowedTerrain.push(i);
		}
		if (r <= 80)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 13, 1000, 1000, 7, 7, null, 0.1, 0.2);
			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_jin_city_location", tile.Coords);
			}
		}
		else
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 14, 1000, 1000, 7, 7, null, 0.2, 0.5);
			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_jin_city2_location", tile.Coords);
			}		
		}
		if (camp != null)
		{
			camp.onSpawned();
			camp.setBanner("banner_jin");
			_faction.addSettlement(camp, false);
		}
	}

});

