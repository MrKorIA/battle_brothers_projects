this.mod_legendary_kriegsgeist_location <- ::inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Разрушенная крепость, источающая холод, как кладбище. По слухам, в ней хранятся большие сокровища, но никто не осмелится посягнуть на их или вторгнуться в эти проклятые руины.";
	}

	function create()
	{
		this.location.create();
		this.m.Name = "Кригсгейст: Форт жутких криков";
		this.m.TypeID = "location.legendary_kriegsgeist_location";
		this.m.LocationType = ::Const.World.LocationType.Lair | ::Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.legendary_kriegsgeist_location_enter";
	}

	function onSpawned()
	{
		::logInfo("Построен легендарный Кригсгейст");
		this.location.onSpawned();
		//this.getSprite("selection").Visible = true;
	}

	function onDiscovered()
	{
		this.location.onDiscovered();
		::World.Flags.increment("LegendaryLocationsDiscovered", 1);

		if (::World.Flags.get("LegendaryLocationsDiscovered") >= 10)
		{
			this.updateAchievement("FamedExplorer", 1, 1);
		}
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(::Math.rand(100, 500), _lootTable);
		this.dropTreasure(::Math.rand(4, 6), [
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/white_pearls_item",
			"loot/ornate_tome_item",
			"loot/jeweled_crown_item",
			"loot/gemstones_item",
			"loot/golden_chalice_item",
			"loot/ancient_gold_coins_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_ruins_undead_stronghold");
		
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.setVisited(false);
		//this.getSprite("selection").Visible = true;
	}

});

