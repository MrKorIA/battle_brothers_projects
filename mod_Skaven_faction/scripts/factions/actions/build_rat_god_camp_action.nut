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

		local avoidTerrain = [
			this.Const.World.TerrainType.Mountains,
			this.Const.World.TerrainType.Impassable,
			this.Const.World.TerrainType.Ocean
		];
		local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 35, 1000, 1000, 7, 7);

		if (tile == null)
		{
			return;
		}

		local camp = this.World.spawnLocation("scripts/entity/world/locations/rat_god_camp_location", tile.Coords);

		if (camp != null)
		{
			camp.setBanner(this.Const.RatBanners[this.Math.rand(0, this.Const.RatBanners.len() - 1)]);
			camp.onSpawned();
			_faction.addSettlement(camp, false);
			this.World.Flags.set("spawnedRatGodCampLocation", true);
			::logInfo("mod_warhammer: размещено Гнездо Рогатой Крысы");
		}
	}

});
