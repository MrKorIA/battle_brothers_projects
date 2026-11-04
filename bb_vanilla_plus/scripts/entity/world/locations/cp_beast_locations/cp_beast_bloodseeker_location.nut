this.cp_beast_bloodseeker_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_bloodseeker";
		this.m.CP_CanSpawnRoamer = true;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Рой Кровососов", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Чудовищные крылатые насекомые, которые нападают на всё что имеет плоть и кровь.");
		party.setFootprintType(::Const.World.FootprintsType.XXMobBloodsucker);
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
			::Const.World.TerrainType.Oasis,
			::Const.World.TerrainType.Swamp,
			::Const.World.TerrainType.LeaveForest,
			::Const.World.TerrainType.AutumnForest
		];
	}
});

