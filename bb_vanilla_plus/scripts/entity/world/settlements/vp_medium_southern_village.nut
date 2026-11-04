this.vp_medium_southern_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Аль-Дамара",
			"Аль-Рималь",
			"Аль-Фажр",
			"Эль-Хафа",
			"Аль-Каср",
			"Аль-Нака",
			"Аль-Захра",
			"Аль-Жадид",
			"Аль-Раджил",
		]);
		this.m.DraftList = [
			// Common
			"butcher_southern_background",
			"butcher_southern_background",
			"caravan_hand_southern_background",
			"caravan_hand_southern_background",
			"cripple_southern_background",
			"cripple_southern_background",
			"daytaler_southern_background",
			"daytaler_southern_background",
			"slave_southern_background",
			"slave_southern_background",

			// Uncommon
			"beggar_southern_background",
			"eunuch_southern_background",
			"gambler_southern_background",
			"historian_southern_background",
			"manhunter_background",
			"nomad_background",
			"nomad_ranged_background",
			"peddler_southern_background",
			"shepherd_southern_background",	// Enough of them get pushed into the list from the guaranteed goat pens
			"servant_southern_background",
			"tailor_southern_background",
			"thief_southern_background",

			// Northern Backgrounds
			"disowned_noble_background",
			"mason_background",
			"refugee_background",
			"vagabond_background",
		];
		this.m.UIDescription = "Разрозненная деревня в пустыне, живущая за счёт торговли и того немногого, что дают пески";
		this.m.Description = "Разрозненная деревня в пустыне, живущая за счёт торговли и того немногого, что дают пески.";

		this.m.UIBackgroundCenter = "ui/settlements/desert_stronghold_03";	// TODO: find a permanent solution
		this.m.UIBackgroundLeft = "ui/settlements/desert_bg_houses_03_left";
		this.m.UIBackgroundRight = "ui/settlements/desert_bg_houses_03_right";
		this.m.UIRampPathway = "ui/settlements/desert_ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/southern_village_townhall_01.png";
		this.m.Sprite = "world_southern_village_townhall_01";
		this.m.Lighting = "world_southern_village_townhall_01_light";
		this.m.Rumors = ::Const.Strings.RumorsDesertSettlement;
		this.m.Culture = ::Const.World.Culture.Southern;
		this.m.IsMilitary = false;
		this.m.Size = 2;
		this.m.HousesType = "_cp_sv01";
		this.m.HousesMin = 3;
		this.m.HousesMax = 3;
		this.m.AttachedLocationsMax = 5;
	}

	function onBuild()
	{
		// Guaranteed Buildings
		this.addBuilding(::new("scripts/entity/world/settlements/buildings/crowd_oriental_building"), 5);
		this.addBuilding(::new("scripts/entity/world/settlements/buildings/vp_marketplace_oriental_village_building"), 2);
		if (::Math.rand(0, 1))
		{
			this.addBuilding(::new("scripts/entity/world/settlements/buildings/barber_building"));
		}
		else
		{
			this.addBuilding(::new("scripts/entity/world/settlements/buildings/temple_oriental_building"));
		}

		switch (::Math.rand(1, 2))
		{
			case 1:
			{
				this.addBuilding(::new("scripts/entity/world/settlements/buildings/weaponsmith_oriental_building"));
				break;
			}
			case 2:
			{
				this.addBuilding(::new("scripts/entity/world/settlements/buildings/armorsmith_oriental_building"));
				break;
			}
		}

		// Ship
		if (this.m.IsCoastal)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/harbor_location", [
				::Const.World.TerrainType.Shore
			], [
				::Const.World.TerrainType.Ocean,
				::Const.World.TerrainType.Shore
			], -1, false, false);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/fishing_huts_oriental_location", [
				::Const.World.TerrainType.Plains,
				::Const.World.TerrainType.Steppe,
				::Const.World.TerrainType.Desert,
				::Const.World.TerrainType.Oasis
			], [
				::Const.World.TerrainType.Shore
			]);
		}

		// Attached Locations
		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/goat_herd_oriental_location", [	// We guarantee one goat pen
			::Const.World.TerrainType.Steppe,
			::Const.World.TerrainType.Desert,
			::Const.World.TerrainType.Oasis
		], []);

		switch (::Math.rand(1, 4))	// We randomly build one of four types of southern attached locations, producing trade goods
		{
			case 1:
			{
				this.buildAttachedLocation(1, "scripts/entity/world/attached_location/incense_dryer_location", [
					::Const.World.TerrainType.Steppe,
					::Const.World.TerrainType.Desert,
					::Const.World.TerrainType.Oasis
				], []);
				break;
			}
			case 2:
			{
				this.buildAttachedLocation(1, "scripts/entity/world/attached_location/silk_farm_location", [
					::Const.World.TerrainType.Steppe,
					::Const.World.TerrainType.Desert,
					::Const.World.TerrainType.Oasis
				], []);
				break;
			}
			case 3:
			{
				this.buildAttachedLocation(1, "scripts/entity/world/attached_location/plantation_location", [
					::Const.World.TerrainType.Steppe,
					::Const.World.TerrainType.Desert,
					::Const.World.TerrainType.Oasis
				], []);
				break;
			}
			case 4:
			{
				this.buildAttachedLocation(1, "scripts/entity/world/attached_location/dye_maker_oriental_location", [
					::Const.World.TerrainType.Steppe,
					::Const.World.TerrainType.Desert,
					::Const.World.TerrainType.Oasis
				], [
					::Const.World.TerrainType.Hills
				]);
				break;
			}
		}

	}

	// Our new southern village faction has the official type "OrientalCityState" for contract/action purposes
	// But that causes it to not be found when this function is called with "Settlement". So we overwrite it and first redirect a search for "Settlement"
	function getFactionOfType( _type )
	{
		if (_type == ::Const.FactionType.Settlement)
		{
			foreach (i in this.m.Factions)
			{
				local f = this.World.FactionManager.getFaction(i);

				if ("VP_SecondaryType" in f.m && f.m.VP_SecondaryType == ::Const.FactionType.Settlement)
				{
					return f;
				}
			}
		}

		return this.settlement.getFactionOfType(_type);
	}

	function isSouthern()
	{
		return true;
	}
});
