::TheRedCourt.HooksMod.hook("scripts/factions/actions/build_unique_locations_action", function(q) {

    q.m.BuildMummySite <- true;

    q.updateBuildings = @(__original) function( )
    {
        __original();

        local locations = this.World.EntityManager.getLocations();

        foreach( v in locations )
        {
            if (v.getTypeID() == "location.legend_mummy")
                this.m.BuildMummySite = false;
        }
    }

    q.onExecute = @(__original) function( _faction )
    {
        __original(_faction);

        local camp;
        local distanceToOthers = 15;

        if (this.m.BuildMummySite)
        {
            local disallowedTerrain = [];

            for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = i )
            {
                if (i == this.Const.World.TerrainType.Desert)
                {
                }
                else
                {
                    disallowedTerrain.push(i);
                }

                i = ++i;
            }

            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, disallowedTerrain, 8, 25, 1001, 8, 8, null, 0.1);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/legendary/legend_mummy_location", tile.Coords);
            }

            if (camp != null)
            {
                camp.onSpawned();
                this.logInfo("Built Legends Ancient Mastaba location");
            }
        }
    }
});