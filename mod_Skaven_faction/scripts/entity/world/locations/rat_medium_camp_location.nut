this.rat_medium_camp_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Деревянный лагерь, построенный на Грызо-норах. Используется скавенами, чтобы прятать добычу, отдыхать между налётами и играть в питейные игры.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.rat_medium_camp";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.rat_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Palisade;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.RatDefenders);
		this.m.Resources = 150;
		this.m.NamedWeaponsList = this.Const.Items.NamedRatWeapons;
		
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.RatWarlordClanCamp);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(100, 300), _lootTable);
		this.dropArmorParts(this.Math.rand(5, 25), _lootTable);
		this.dropAmmo(this.Math.rand(0, 40), _lootTable);
		this.dropMedicine(this.Math.rand(0, 3), _lootTable);
		local treasure = [
			"loot/signet_ring_item",
			"trade/rat_crystal_item",
			"loot/rat_fragment_item",
			"loot/rat_fragment_item"
		];

		if (this.Const.DLC.Unhold)
		{
			treasure.extend(treasure);
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

		this.dropFood(this.Math.rand(1, 3), [
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
		body.setBrush("world_rat_camp_02");
	}

});

