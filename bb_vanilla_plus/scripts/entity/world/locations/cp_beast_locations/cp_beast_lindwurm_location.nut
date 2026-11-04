this.cp_beast_lindwurm_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_lindwurm";

		this.m.CP_CanSpawnRoamer = true;
		this.m.Resources *= 1.5;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Линдвурмы", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Линдвурм - бескрылый двуногий дракон, похожий на гигантскую змею.");
		party.setFootprintType(::Const.World.FootprintsType.Lindwurms);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setLooting(false);
		return party;
	}

	function getLikeableTerrain()
	{
		return [
			::Const.World.TerrainType.Forest,
			::Const.World.TerrainType.LeaveForest,
			::Const.World.TerrainType.AutumnForest,
			::Const.World.TerrainType.Desert,
			::Const.World.TerrainType.Steppe,
		];
	}
});

