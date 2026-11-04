this.cp_beast_hyena_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_hyena";
		this.m.CP_CanSpawnRoamer = true;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Гиены", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Стая злобных гиен на охоте.");
		party.setFootprintType(::Const.World.FootprintsType.Hyenas);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setLooting(false);

		party.setVisibilityMult(0.6);
		party.setMovementSpeed(party.getBaseMovementSpeed() * 0.9);  // Beasts are easier to catch

		return party;
	}

	function getLikeableTerrain()
	{
		return [
			::Const.World.TerrainType.Desert,
			::Const.World.TerrainType.Oasis,
			::Const.World.TerrainType.Steppe,
			::Const.World.TerrainType.Hills,
		];
	}
});

