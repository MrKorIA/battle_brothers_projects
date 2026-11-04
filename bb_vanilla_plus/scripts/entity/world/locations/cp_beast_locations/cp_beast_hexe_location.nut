this.cp_beast_hexe_location <- this.inherit("scripts/entity/world/locations/cp_beast_cave_location", {
	m = {},

	function create()
	{
		this.cp_beast_cave_location.create();
		this.m.TypeID = "location.cp_beast_hexe";

		this.m.CP_CanSpawnRoamer = true;
		this.m.Resources *= 1.5;	// Hexen Locations have 50% more resources than a regular cave

		// cp_beast_cave_location hides the defenders and banner, so we need to re-enable it here again
		this.m.IsShowingBanner = true;
		this.m.IsShowingDefenders = true;

		this.m.CP_TacticalTypeOverwrite = null;
		this.m.CP_EngageImageOverwrite = null;
		this.m.CP_TacticalTextOverwrite = null;
	}

	function getDescription()
	{
		return "Старая покосившаяся хибара, выглядящая так, словно готова рухнуть в любой момент. Из кривой трубы вьётся дымок.";
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_witch_hut");
	}

	function onSpawned()
	{
		this.m.Name = ::World.EntityManager.getUniqueLocationName(::Const.World.LocationNames.WitchHut);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);

		// One treasure item is guaranteed
		local regularTreasure = ::MSU.Class.WeightedContainer([
			[12, "loot/jade_broche_item"],
			[12, "loot/silver_bowl_item"],
			[12, "loot/silverware_item"],
			// Witch Huts sometimes drop one vial, which you normally only get from a contract twist
			[6, "special/bodily_reward_item"],
			[6, "special/spiritual_reward_item"],
		]);
		this.dropTreasure(1, [regularTreasure.roll()], _lootTable);

		// Witch Huts drop 2 food items
		local food = ::MSU.Class.WeightedContainer([
			[12, "roots_and_berries_item"],
			[12, "pickled_mushrooms_item"],
			[12, "black_marsh_stew_item"],
		]);
		this.dropFood(2, [food.roll()], _lootTable);
	}

// New Functions
	function spawnScaledRoamingParty( _scaling )
	{
		local resources = this.getResources() * _scaling;
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.getTile(), "Ведьмы", false, this.getRoamerSpawnList(), resources);
		party.setDescription("Старые и злые карги, что по слухам одурманивают и похищают маленьких детей для своих зелий и жуткой похлёбки, заключают зловещие договоры с жителями глухих деревушек и насылают проклятья.");
		party.setFootprintType(::Const.World.FootprintsType.Hexen);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setLooting(false);

		party.setVisibilityMult(1.0);	// Hexen don't know how to hide
		party.setMovementSpeed(party.getBaseMovementSpeed() * 0.8);  // Hexen are not very fast

		return party;
	}

	function getLikeableTerrain()
	{
		return [
			::Const.World.TerrainType.Land,
			::Const.World.TerrainType.Plains,
			::Const.World.TerrainType.Swamp,
			::Const.World.TerrainType.Forest,
			::Const.World.TerrainType.LeaveForest,
			::Const.World.TerrainType.AutumnForest,
			::Const.World.TerrainType.Urban,
			::Const.World.TerrainType.Farmland,
			::Const.World.TerrainType.Badlands,
			::Const.World.TerrainType.Tundra,
			::Const.World.TerrainType.Steppe,
		];
	}
});

