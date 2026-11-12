// Легендарная локация «Гнездо Рогатой Крысы» — объединённый лагерь варваров и скавенов.
// Бой только через событие входа (scripts/events/events/rat_god_camp_enter_event.nut):
// скриптованная расстановка (варвары на севере, скавены на востоке) и цепочка
// реинкарнаций Повелителя тварей (01 → 02 → 03) возможны только в событийном бое.
this.rat_god_camp_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Огромное стойбище, где бок о бок живут варвары и скавены. Посреди лагеря возвышается идол Рогатой Крысы, которому поклоняются оба племени.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.rat_god_camp";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.rat_god_camp_enter";
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.RatGodCamp);
		this.location.onSpawned();
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

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(300, 700), _lootTable);
		this.dropArmorParts(this.Math.rand(20, 40), _lootTable);
		this.dropAmmo(this.Math.rand(10, 40), _lootTable);
		this.dropMedicine(this.Math.rand(0, 8), _lootTable);
		this.dropTreasure(this.Math.rand(3, 5), [
			"trade/furs_item",
			"trade/rat_crystal_item",
			"loot/rat_crystal_item",
			"loot/silver_bowl_item",
			"loot/silverware_item"
		], _lootTable);
		this.dropFood(this.Math.rand(2, 4), [
			"rat_soup_item",
			"rat_meat_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_rat_camp_03");
	}

});
