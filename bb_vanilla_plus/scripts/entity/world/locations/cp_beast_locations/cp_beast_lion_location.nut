this.cp_beast_lion_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_lion";
		this.m.CP_CanSpawnRoamer = true;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Прайд львов", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Львы — цари животных. Лучше держаться стороной от них.");
		party.setFootprintType(::Const.World.FootprintsType.XXMobLion);
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
			::Const.World.TerrainType.Steppe,
			::Const.World.TerrainType.Desert,
			::Const.World.TerrainType.Oasis,
			::Const.World.TerrainType.Hills
		];
	}
});

