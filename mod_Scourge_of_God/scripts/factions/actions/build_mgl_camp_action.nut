this.build_mgl_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_mgl_camp_action";
		this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{

		if (this.World.getTime().Days < 50)
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
		local r = this.Math.rand(1, 2);

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
		{
			if (i == ::Const.World.TerrainType.Land || i == ::Const.World.TerrainType.Steppe || i == ::Const.World.TerrainType.Badlands || i == ::Const.World.TerrainType.Tundra)
			{
				continue;
			}

			disallowedTerrain.push(i);
		}
		if (r == 1)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 15, 1000, 1000, 7, 7, null, 0.5, 0.75);
			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_mgl_city_location", tile.Coords);
			}
		}
		else
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 13, 1000, 1000, 7, 7, null, 0.5, 0.75);
			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_mgl_city2_location", tile.Coords);
			}		
		}
		if (camp != null)
		{
		    local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 15, ::Const.MglBanners);
			camp.onSpawned();
			camp.setBanner(banner);
			_faction.addSettlement(camp, false);
		}
	}

});

