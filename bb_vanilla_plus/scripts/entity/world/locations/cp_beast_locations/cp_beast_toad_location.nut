this.cp_beast_toad_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_toad";
		this.m.CP_CanSpawnRoamer = true;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Гигантские жабы", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Колония жаб, которые облюбовали ближайшую местность. Агрессивны ко всему живому.");
		party.setFootprintType(::Const.World.FootprintsType.XXMobToad);
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
			::Const.World.TerrainType.Oasis,
			::Const.World.TerrainType.Swamp
		];
	}
});

