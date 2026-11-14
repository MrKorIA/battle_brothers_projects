// Деревянная сторожевая башня: raidable-военная пристройка (порт из mod_hardened)
::ReforgedLite.HooksMod.hook("scripts/entity/world/attached_location/wooden_watchtower_location", function(q) {
	// Набеги (Hardened). Отдельной функцией, т.к. сейвы не хранят эти поля —
	// применяем в create и onDeserialize
	local function applyRaidSetup( _location )
	{
		_location.m.IsAttackable = true;
		_location.m.IsScalingDefenders = true;

		// Тактическая карта
		_location.m.CombatLocation.Template[0] = "tactical.human_camp";
		_location.m.CombatLocation.Fortification = ::Const.Tactical.FortificationType.Palisade;
		_location.m.CombatLocation.CutDownTrees = true;
		_location.m.CombatLocation.AdditionalRadius = 0;

		// Защитники
		_location.m.Resources = 150;
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
		if (this.m.Resources == 0) this.m.Resources = 150;
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

		this.dropFood(::Math.rand(1, 3), [
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
	}}.onDropLootForPlayer;
});
