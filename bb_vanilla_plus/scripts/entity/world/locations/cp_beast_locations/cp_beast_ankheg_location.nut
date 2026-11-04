this.cp_beast_ankheg_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_ankheg";
		this.m.CP_CanSpawnRoamer = true;
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Рой анхегов", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Анхег похож на огромное насекомое с множеством лап. Его длинные усики подергиваются, реагируя на любое движение вокруг. На концах его лап огромные крюки, пригодные как для рытья, так и для того, чтобы хватать добычу. Его мощные челюсти способны перекусить небольшое дерево пополам. Также анхег может плеваться кислотой в своих врагов.");
		party.setFootprintType(::Const.World.FootprintsType.XXMobAnkheg);
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
			::Const.World.TerrainType.Hills,
			::Const.World.TerrainType.Desert,
			::Const.World.TerrainType.Steppe
		];
	}
});

