this.cp_beast_unhold_frost_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_unhold_frost";
		this.m.CP_CanSpawnRoamer = true;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Тролли", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Один или несколько неуклюжих великанов.");
		party.setFootprintType(::Const.World.FootprintsType.Unholds);
		party.setSlowerAtNight(true);
		party.setUsingGlobalVision(false);
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setLooting(false);

		party.getFlags().set("IsUnholds", true);
		return party;
	}

	function getLikeableTerrain()
	{
		return [
			::Const.World.TerrainType.Snow,
			::Const.World.TerrainType.SnowyForest,
			::Const.World.TerrainType.Hills,
		];
	}
});

