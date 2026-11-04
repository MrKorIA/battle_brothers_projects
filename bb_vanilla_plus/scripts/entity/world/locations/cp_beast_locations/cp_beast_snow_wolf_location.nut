this.cp_beast_snow_wolf_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.beast_snow_wolf";
		this.m.CP_CanSpawnRoamer = true;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Снежные Лютоволки", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Стая свирепых снежных лютоволков в поисках жертвы.");
		party.setFootprintType(::Const.World.FootprintsType.XXMobWhiteWolf);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setLooting(false);

		party.setVisibilityMult(0.6);

		return party;
	}

	function getLikeableTerrain()
	{
		return [
			::Const.World.TerrainType.Forest,
			::Const.World.TerrainType.SnowyForest,
			::Const.World.TerrainType.LeaveForest,
			::Const.World.TerrainType.AutumnForest,
			::Const.World.TerrainType.Hills,
			::Const.World.TerrainType.Snow,
			::Const.World.TerrainType.Tundra
		];
	}
});

