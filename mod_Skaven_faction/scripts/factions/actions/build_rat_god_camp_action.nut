this.build_rat_god_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_rat_god_camp_action";
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (this.World.Flags.get("spawnedRatGodCampLocation"))
		{
			return;
		}

		this.m.Score = 2000;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		if (this.World.Flags.get("spawnedRatGodCampLocation"))
		{
			return;
		}

		local avoidTerrain = [];
        for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
        {
            if (i != this.Const.World.TerrainType.Tundra)
            {
                avoidTerrain.push(i);
            }
        }
		local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 35, 1000, 1000, 7, 7);

		if (tile == null)
		{
			return;
		}

		local camp = this.World.spawnLocation("scripts/entity/world/locations/rat_god_camp_location", tile.Coords);

		if (camp != null)
		{
			camp.onSpawned();
			_faction.addSettlement(camp, false);
			this.World.Flags.set("spawnedRatGodCampLocation", true);
			::logInfo("mod_warhammer: размещено Гнездо Рогатой Крысы");
		}
	}

});
