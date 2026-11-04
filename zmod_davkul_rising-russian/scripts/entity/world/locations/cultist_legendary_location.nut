//legendary base that needs to be defeated to stop the cultist menace once and for all
this.cultist_legendary_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Древнее место поклонения. Недавно его заняла новая секта культистов, приносящая людей в жертву во имя Давкула.";
	}

	function create() 
	{
		this.location.create();
		this.m.TypeID = "location.cultist_legendary_camp";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.CombatLocation.Template[0] = "tactical.cultist_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 10;
		this.m.IsShowingDefenders = true;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.cultist_legendary_enter";
		this.m.OnDestroyed = "event.location.cultist_legendary_destroyed";
	}

	function onDiscovered()
	{
		this.location.onDiscovered();
		this.World.Flags.increment("LegendaryLocationsDiscovered", 1);

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 10)
		{
			this.updateAchievement("FamedExplorer", 1, 1);
		}
	}

	function onBeforeCombatStarted()
	{
		this.location.onBeforeCombatStarted();
	}

	function onSpawned()
	{
		this.m.Name = "Великое святилище"
		this.location.onSpawned();
		#this.Const.World.Common.addTroop(this, {Type = this.Const.World.Spawn.Troops.Cultist_High_Priest}, false, 100);
		local Troops = 
		[
			
			{
			Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
			Num = 13
			},
			{
			Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
			Num = 7
			},
			{
			Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
			Num = 7
			},
			{
			Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
			Num = 4
			},
			{
			Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
			Num = 6
			},
			{
			Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
			Num = 1
			},
			{
			Type = this.Const.World.Spawn.Troops.Cultist_High_Priest,
			Num = 1
			},
		]
		foreach(troop in Troops)
		{
			for( local i = 0; i < troop.Num; i = ++i )
			{
				this.Const.World.Common.addTroop(this, {Type = troop.Type}, false);
			}
		}

		
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(1500, 3000), _lootTable);
		this.dropArmorParts(this.Math.rand(50, 100), _lootTable);
		this.dropAmmo(this.Math.rand(50, 100), _lootTable);
		this.dropMedicine(this.Math.rand(20, 40), _lootTable);
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
		this.dropTreasure(this.Math.rand(4, 6), treasure, _lootTable);

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
	function onCombatLost()
	{
		this.location.onCombatLost()
		local cultists = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists)
		cultists.m.Flags.set("CultistLegendaryLocationBeat", true)

	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_cult_camp_legendary")
	}

});


