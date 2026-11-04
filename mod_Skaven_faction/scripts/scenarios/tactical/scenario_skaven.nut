this.scenario_skaven <- this.inherit("scripts/scenarios/tactical/scenario_template", {
	m = {},
	function generate()
	{
		this.logDebug("ScenarioSkaven::generate()");
		this.createStash();
		this.initMap();
		this.initEntities();
		this.initStash();
		this.Tactical.Entities.makeEnemiesKnownToAI();
		this.m.Music = this.Const.Music.RatTracks;
		this.Tactical.getCamera().Level = 1;
		this.Tactical.CameraDirector.addMoveToTileEvent(0, this.Tactical.getTile(15, 14 - 15 / 2), 1, null, null, 0, 100);
	}

	function initMap()
	{
		local testMap = this.MapGen.get("tactical.combat_basics");
		local minX = testMap.getMinX();
		local minY = testMap.getMinY();
		this.Tactical.resizeScene(minX, minY);
		testMap.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY
		}, null);
	}

	function initEntities()
	{
		local entity;
		local items;
		entity = this.spawnEntity("scripts/entity/tactical/player", 12, 12, 17, 17);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/armor/leather_lamellar"));
		items.addToBag(this.new("scripts/items/weapons/dagger"));
		local banner = this.new("scripts/items/tools/player_banner");
		banner.setVariant(2);
		items.equip(banner);
		entity = this.spawnEntity("scripts/entity/tactical/player", 12, 12, 15, 15);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/kettle_hat"));
		items.equip(this.new("scripts/items/armor/padded_leather"));
		items.equip(this.new("scripts/items/weapons/billhook"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 12, 12, 13, 13);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/armor/leather_tunic"));
		items.equip(this.new("scripts/items/weapons/longaxe"));
		items.equip(this.new("scripts/items/helmets/hood"));
		items.addToBag(this.new("scripts/items/weapons/dagger"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 11, 11, 14, 14);
		this.World.getPlayerRoster().add(entity);
		entity.setFaction(this.Const.Faction.Player);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		items.equip(this.new("scripts/items/armor/sackcloth"));
		items.equip(this.new("scripts/items/weapons/short_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		items.addToBag(this.new("scripts/items/weapons/dagger"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 11, 11, 15, 15);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		items.equip(this.new("scripts/items/armor/gambeson"));
		items.equip(this.new("scripts/items/weapons/crossbow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		items.addToBag(this.new("scripts/items/weapons/dagger"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 13, 13, 11, 11);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/kettle_hat"));
		items.equip(this.new("scripts/items/armor/lamellar_harness"));
		items.equip(this.new("scripts/items/weapons/greataxe"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 13, 13, 12, 12);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		items.equip(this.new("scripts/items/armor/padded_leather"));
		items.equip(this.new("scripts/items/weapons/noble_sword"));
		items.equip(this.new("scripts/items/shields/heater_shield"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 13, 13, 13, 13);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/named/norse_helmet"));
		items.equip(this.new("scripts/items/armor/reinforced_mail_hauberk"));
		items.equip(this.new("scripts/items/weapons/hand_axe"));
		items.equip(this.new("scripts/items/shields/wooden_shield"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 13, 13, 14, 14);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/hood"));
		items.equip(this.new("scripts/items/armor/mail_shirt"));
		items.equip(this.new("scripts/items/weapons/boar_spear"));
		items.equip(this.new("scripts/items/shields/wooden_shield"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 13, 13, 15, 15);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/bascinet_with_mail"));
		items.equip(this.new("scripts/items/armor/mail_hauberk"));
		items.equip(this.new("scripts/items/weapons/warhammer"));
		items.equip(this.new("scripts/items/shields/wooden_shield"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 13, 13, 16, 16);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		items.equip(this.new("scripts/items/weapons/winged_mace"));
		items.equip(this.new("scripts/items/shields/wooden_shield"));
		entity = this.spawnEntity("scripts/entity/tactical/player", 13, 13, 17, 17);
		this.World.getPlayerRoster().add(entity);
		entity.setName(this.getRandomPlayerName());
		entity.setScenarioValues();
		items = entity.getItems();
		items.equip(this.new("scripts/items/helmets/mail_coif"));
		items.equip(this.new("scripts/items/armor/coat_of_plates"));
		items.equip(this.new("scripts/items/weapons/greatsword"));
		entity = this.spawnEntity("scripts/entity/tactical/enemies/rat_queek", 14, 14, 12, 12);
		entity.setFaction(this.Const.Faction.Rat);
		entity.assignRandomEquipment();
		entity = this.spawnEntity("scripts/entity/tactical/enemies/rat_queek", 14, 14, 15, 15);
		entity.setFaction(this.Const.Faction.Rat);
		entity.assignRandomEquipment();

	}

	function spawnEntity( _script, _minX = 10, _maxX = 28, _minY = 3, _maxY = 28 )
	{
		local x = 0;
		local y = 0;
		local n = 0;

		while (1)
		{
			x = this.Math.rand(_minX, _maxX);
			y = this.Math.rand(_minY, _maxY) - x / 2;

			if (this.Tactical.getTile(x, y).IsOccupiedByActor)
			{
				continue;
			}

			this.Tactical.getTile(x, y).removeObject();

			if (this.Tactical.getTile(x, y).IsEmpty)
			{
				break;
			}
		}

		return this.Tactical.spawnEntity(_script, x, y);
	}

	function initStash()
	{
		this.Stash.clear();
		this.Stash.resize(117);
		this.Stash.setLocked(false);
		this.Stash.add(this.new("scripts/items/accessory/rat_trophy_item"));
		this.Stash.add(this.new("scripts/items/armor_upgrades/ratorge_bone_platings_upgrade"));
		this.Stash.add(this.new("scripts/items/armor_upgrades/ratorge_fur_upgrade"));
		this.Stash.add(this.new("scripts/items/armor_upgrades/wolfrat_pelt_upgrade"));
		this.Stash.add(this.new("scripts/items/weapons/named/dwarf_gouger_blade"));
		this.Stash.add(this.new("scripts/items/weapons/named/dwarf_gouger_hammer"));
		this.Stash.add(this.new("scripts/items/weapons/named/grey_seer_flail"));
		this.Stash.add(this.new("scripts/items/weapons/rat_totem"));
		this.Stash.add(this.new("scripts/items/weapons/rat_packmaster_creature_killer"));
		this.Stash.add(this.new("scripts/items/weapons/rat_tretch_flail"));
		this.Stash.add(this.new("scripts/items/weapons/rat_warpfire_thrower"));
		this.Stash.add(this.new("scripts/items/accessory/plague_cured_item"));
		this.Stash.add(this.new("scripts/items/armor/warp_shard_armor_03"));
		this.Stash.add(this.new("scripts/items/helmets/human_tretch_helmet"));
		this.Stash.add(this.new("scripts/items/tools/plague_bomb_item"));
		this.Stash.add(this.new("scripts/items/ammo/large_powder_bag"));
		this.Stash.add(this.new("scripts/items/armor/human_tretch_armor"));
		this.Stash.add(this.new("scripts/items/helmets/warp_shard_helmet"));
		this.Stash.add(this.new("scripts/items/accessory/rat_charm_item"));
		this.Stash.add(this.new("scripts/items/armor/human_tretch_armor"));
		this.Stash.add(this.new("scripts/items/weapons/craftable_ratbeast_whip"));
		this.Stash.add(this.new("scripts/items/weapons/military_cleaver"));
		this.Stash.add(this.new("scripts/items/weapons/military_cleaver"));
		this.Stash.add(this.new("scripts/items/weapons/greatsword"));
		this.Stash.add(this.new("scripts/items/weapons/greatsword"));
		this.Stash.add(this.new("scripts/items/weapons/greatsword"));
		this.Stash.add(this.new("scripts/items/weapons/greatsword"));
		this.Stash.add(this.new("scripts/items/weapons/greataxe"));
		this.Stash.add(this.new("scripts/items/weapons/greataxe"));
		this.Stash.add(this.new("scripts/items/weapons/greataxe"));
		this.Stash.add(this.new("scripts/items/weapons/billhook"));
		this.Stash.add(this.new("scripts/items/weapons/billhook"));
		this.Stash.add(this.new("scripts/items/weapons/billhook"));
		this.Stash.add(this.new("scripts/items/weapons/militia_spear"));
		this.Stash.add(this.new("scripts/items/weapons/militia_spear"));
		this.Stash.add(this.new("scripts/items/weapons/boar_spear"));
		this.Stash.add(this.new("scripts/items/weapons/boar_spear"));
		this.Stash.add(this.new("scripts/items/weapons/boar_spear"));
		this.Stash.add(this.new("scripts/items/weapons/bludgeon"));
		this.Stash.add(this.new("scripts/items/weapons/bludgeon"));
		this.Stash.add(this.new("scripts/items/weapons/named/named_dagger"));
		this.Stash.add(this.new("scripts/items/weapons/named/named_dagger"));
		this.Stash.add(this.new("scripts/items/weapons/named/named_dagger"));
		this.Stash.add(this.new("scripts/items/weapons/named/named_dagger"));
		this.Stash.add(this.new("scripts/items/weapons/flail"));
		this.Stash.add(this.new("scripts/items/weapons/flail"));
		this.Stash.add(this.new("scripts/items/weapons/flail"));
		this.Stash.add(this.new("scripts/items/weapons/named/named_dagger"));
		this.Stash.add(this.new("scripts/items/weapons/named/named_dagger"));
		this.Stash.add(this.new("scripts/items/weapons/hunting_bow"));
		this.Stash.add(this.new("scripts/items/weapons/hunting_bow"));
		this.Stash.add(this.new("scripts/items/weapons/crossbow"));
		this.Stash.add(this.new("scripts/items/weapons/crossbow"));
		this.Stash.add(this.new("scripts/items/weapons/crossbow"));
		this.Stash.add(this.new("scripts/items/shields/wooden_shield"));
		this.Stash.add(this.new("scripts/items/shields/wooden_shield"));
		this.Stash.add(this.new("scripts/items/shields/kite_shield"));
		this.Stash.add(this.new("scripts/items/shields/kite_shield"));
		this.Stash.add(this.new("scripts/items/shields/kite_shield"));
		this.Stash.add(this.new("scripts/items/helmets/hood"));
		this.Stash.add(this.new("scripts/items/helmets/aketon_cap"));
		this.Stash.add(this.new("scripts/items/helmets/full_aketon_cap"));
		this.Stash.add(this.new("scripts/items/helmets/nasal_helmet"));
		this.Stash.add(this.new("scripts/items/helmets/padded_nasal_helmet"));
		this.Stash.add(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		this.Stash.add(this.new("scripts/items/helmets/mail_coif"));
		this.Stash.add(this.new("scripts/items/helmets/closed_mail_coif"));
		this.Stash.add(this.new("scripts/items/helmets/reinforced_mail_coif"));
		this.Stash.add(this.new("scripts/items/helmets/kettle_hat"));
		this.Stash.add(this.new("scripts/items/helmets/padded_kettle_hat"));
		this.Stash.add(this.new("scripts/items/helmets/kettle_hat_with_mail"));
		this.Stash.add(this.new("scripts/items/helmets/flat_top_helmet"));
		this.Stash.add(this.new("scripts/items/helmets/flat_top_with_mail"));
		this.Stash.add(this.new("scripts/items/helmets/full_helm"));
		this.Stash.add(this.new("scripts/items/helmets/full_helm"));
		this.Stash.add(this.new("scripts/items/armor/padded_surcoat"));
		this.Stash.add(this.new("scripts/items/armor/gambeson"));
		this.Stash.add(this.new("scripts/items/armor/gambeson"));
		this.Stash.add(this.new("scripts/items/armor/padded_leather"));
		this.Stash.add(this.new("scripts/items/armor/padded_leather"));
		this.Stash.add(this.new("scripts/items/armor/mail_shirt"));
		this.Stash.add(this.new("scripts/items/armor/mail_shirt"));
		this.Stash.add(this.new("scripts/items/armor/mail_shirt"));
		this.Stash.add(this.new("scripts/items/armor/lamellar_harness"));
		this.Stash.add(this.new("scripts/items/armor/coat_of_plates"));
		this.Stash.add(this.new("scripts/items/ammo/quiver_of_arrows"));
		this.Stash.add(this.new("scripts/items/ammo/quiver_of_arrows"));
		this.Stash.add(this.new("scripts/items/ammo/quiver_of_arrows"));
		this.Stash.add(this.new("scripts/items/ammo/quiver_of_arrows"));
		this.Stash.add(this.new("scripts/items/ammo/quiver_of_bolts"));
		this.Stash.add(this.new("scripts/items/ammo/quiver_of_bolts"));
		this.Stash.add(this.new("scripts/items/ammo/quiver_of_bolts"));
	}

});

