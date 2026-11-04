//runs once to spawn the legendary base somewhere


this.spawn_cultist_legendary_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "spawn_cultist_legendary_camp_action";
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (this.World.Flags.get("spawnedLegendaryCultistLocation")) return
		this.m.Score = 2000;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local camp;
		local tile;
		local avoidTerrain = [
		this.Const.World.TerrainType.Mountains, 
		]
		local ritualsSpawned = 0;
		local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 35, 1000, 1000, 7, 7);

		if (tile != null)
		{
			camp = this.World.spawnLocation("scripts/entity/world/locations/cultist_legendary_location", tile.Coords);
		}
		if (camp != null)
		{
			camp.onSpawned();
			camp.setBanner("banner_13")
			_faction.addSettlement(camp, false);
			_faction.getFlags().set("addedLegendaryCultistLocation", true)
			this.World.Flags.set("spawnedLegendaryCultistLocation", true)
			this.printDebug("размещена легендарная локация культистов", "mod_cultists")
		}
	}
});

