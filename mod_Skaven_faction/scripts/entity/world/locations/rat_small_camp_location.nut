this.rat_small_camp_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Грызо-норы разрывают кожу реальности, открываясь, как раны, и позволяя неистовым полчищам скавенов хлынуть наружу.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.rat_small_camp";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.rat_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.RatDefenders);
		this.m.Resources = 70;
		this.m.NamedWeaponsList = this.Const.Items.NamedRatWeapons;
		
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.RatMinorClanCamp);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(50, 150), _lootTable);
		this.dropArmorParts(this.Math.rand(0, 10), _lootTable);
		this.dropAmmo(this.Math.rand(0, 10), _lootTable);
		local treasure = [
			"loot/signet_ring_item",
			"loot/rat_fragment_item"
		];
		this.dropFood(this.Math.rand(1, 2), [
			"rat_meat_item",
			"rat_soup_item"
		], _lootTable);
		this.dropTreasure(1, treasure, _lootTable);

		if (this.Const.DLC.Unhold && this.Math.rand(1, 100) <= 10)
		{
			local treasure = [];
			treasure.push("misc/paint_set_item");
			treasure.push("misc/paint_black_item");
			treasure.push("misc/paint_red_item");
			treasure.push("misc/paint_orange_red_item");
			treasure.push("misc/paint_white_blue_item");
			treasure.push("misc/paint_white_green_yellow_item");
			this.dropTreasure(1, treasure, _lootTable);
		}
	}


	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_rat_camp_01");
	}

});

