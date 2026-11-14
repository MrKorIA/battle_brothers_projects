// Каменная сторожевая башня: raidable-военная пристройка (порт из mod_hardened) + магазин rf-предметов
::ReforgedLite.HooksMod.hook("scripts/entity/world/attached_location/stone_watchtower_location", function(q) {
	// Набеги (Hardened). Отдельной функцией, т.к. сейвы не хранят эти поля —
	// применяем в create и onDeserialize
	local function applyRaidSetup( _location )
	{
		_location.m.IsAttackable = true;
		_location.m.IsScalingDefenders = true;

		// Тактическая карта
		_location.m.CombatLocation.Template[0] = "tactical.human_camp";
		_location.m.CombatLocation.Fortification = ::Const.Tactical.FortificationType.Walls;
		_location.m.CombatLocation.CutDownTrees = true;
		_location.m.CombatLocation.AdditionalRadius = 0;

		// Защитники
		_location.m.Resources = 200;
		_location.setDefenderSpawnList(::Const.World.Spawn.Noble);

		_location.m.IsRaidable = true;
	}

	q.create = @(__original) { function create()
	{
		__original();
		applyRaidSetup(this);
	}}.create;

	q.onDeserialize = @(__original) { function onDeserialize( _in )
	{
		__original(_in);
		applyRaidSetup(this);
		// Сейвы до появления фичи: ресурсов нет, без них защитники не заспавнятся
		if (this.m.Resources == 0) this.m.Resources = 200;
		this.setAttackable(this.isActive());
		this.HD_ensureRaidFaction();
	}}.onDeserialize;

	q.onDropLootForPlayer = @(__original) { function onDropLootForPlayer( _lootTable )
	{
		__original(_lootTable);
		this.dropAmmo(::Math.rand(this.m.Resources / 20, this.m.Resources / 5), _lootTable);
		this.dropArmorParts(::Math.rand(this.m.Resources / 40, this.m.Resources / 10), _lootTable);
		this.dropMedicine(::Math.rand(this.m.Resources / 80, this.m.Resources / 20), _lootTable);
		this.dropMoney(::Math.rand(this.m.Resources / 4, this.m.Resources), _lootTable);

		this.dropFood(::Math.rand(2, 4), [
			"bread_item",
			"beer_item",
			"dried_fruits_item",
			"ground_grains_item",
			"roots_and_berries_item",
			"pickled_mushrooms_item",
			"smoked_ham_item",
			"mead_item",
			"cured_venison_item",
			"goat_cheese_item",
		], _lootTable);

		local paintList = [
			"misc/paint_set_item",
			"misc/paint_set_item",
			"misc/paint_set_item",
			"misc/paint_black_item",
			"misc/paint_red_item",
			"misc/paint_orange_red_item",
			"misc/paint_white_blue_item",
			"misc/paint_white_green_yellow_item",
		];
		this.dropTreasure(1, paintList, _lootTable);
	}}.onDropLootForPlayer;

	q.onUpdateShopList = @(__original) { function onUpdateShopList( _id, _list )
	{
		switch (_id)
		{
			case "building.marketplace":
				if (!this.getSettlement().isSouthern())
				{
					_list.extend([
						{
							R = 50,
							P = 1.0,
							S = "helmets/rf_scale_helmet"
						},
						{
							R = 60,
							P = 1.0,
							S = "helmets/rf_padded_scale_helmet"
						},
						{
							R = 80,
							P = 1.0,
							S = "weapons/rf_reinforced_wooden_poleflail"
						}
					]);
				}
				break;
		}

		return __original(_id, _list);
	}}.onUpdateShopList;
});
