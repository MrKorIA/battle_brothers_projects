this.cp_beast_boar_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_boar";
		this.m.CP_CanSpawnRoamer = true;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Шиповепри", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Шиповепри — чудовищные создания, их шкура покрыта острыми шипами, которые легко отлетают при ударах впиваясь в плоть и доспехи.");
		party.setFootprintType(::Const.World.FootprintsType.XXMobBoar);
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
		];
	}
});

