
this.cultist_ritual_site_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Древнее место поклонения, по слухам, всё ещё используемое по назначению.";
	}

	function create() 
	{
		this.location.create();
		this.m.TypeID = "location.cultist_minor_ritual_site";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.cultist_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.setDefenderSpawnList(this.Const.World.Spawn.CultistDefenders);
		this.m.IsShowingDefenders = true;
		this.m.IsDespawningDefenders = false;
		this.m.Resources = 350;
		this.m.IsShowingBanner = true;
		this.m.NamedWeaponsList = this.Const.Items.NamedCultistWeapons;
		this.m.NamedHelmetsList = this.Const.Items.NamedCultistHelmets;
	}

	function onSpawned()
	{
		this.m.Name = "Святилище"
		this.location.onSpawned();
	}
	function createDefenders()
	{
		this.getCultists().recomputeFanatics(this.Const.World.Spawn.CultistDefenders)
		this.location.createDefenders()
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		for (local i = 0; i < 2; i++) {
		    _lootTable.push(this.new("scripts/items/accessory/sacrificial_collar_item"))
		}
		this.dropMoney(this.Math.rand(200, 500), _lootTable);
		this.dropArmorParts(this.Math.rand(15, 30), _lootTable);
		this.dropAmmo(this.Math.rand(0, 30), _lootTable);
		this.dropMedicine(this.Math.rand(0, 5), _lootTable);
		local treasure = [
			"trade/furs_item",
			"trade/copper_ingots_item",
			"trade/cloth_rolls_item",
			"trade/salt_item",
			"trade/amber_shards_item",
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item"
		];

		if (this.Const.DLC.Unhold)
		{
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.push("armor_upgrades/metal_plating_upgrade");
			treasure.push("armor_upgrades/metal_pauldrons_upgrade");
			treasure.push("armor_upgrades/mail_patch_upgrade");
			treasure.push("armor_upgrades/leather_shoulderguards_upgrade");
			treasure.push("armor_upgrades/leather_neckguard_upgrade");
			treasure.push("armor_upgrades/joint_cover_upgrade");
			treasure.push("armor_upgrades/heraldic_plates_upgrade");
			treasure.push("armor_upgrades/double_mail_upgrade");
		}

		this.dropFood(this.Math.rand(2, 4), [
			"bread_item",
			"beer_item",
			"dried_fruits_item",
			"ground_grains_item",
			"roots_and_berries_item",
			"pickled_mushrooms_item",
			"smoked_ham_item",
			"mead_item",
			"cured_venison_item",
			"goat_cheese_item"
		], _lootTable);
		this.dropTreasure(this.Math.rand(1, 2), treasure, _lootTable);

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
		body.setBrush("world_cult_camp_ritual")

	}

	function onCombatLost()
	{
		this.location.onCombatLost()
		if (!this.getCultists().m.Flags.has("RitualSitesBeat")) this.getCultists().m.Flags.set("RitualSitesBeat", 0)
		this.getCultists().m.Flags.increment("RitualSitesBeat")
		this.getCultists().m.Flags.set("DelayUntilRitualSite", this.World.getTime().Days + 7)

	}

});


