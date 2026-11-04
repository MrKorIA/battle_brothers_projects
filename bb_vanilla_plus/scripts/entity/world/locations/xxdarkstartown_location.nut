this.xxdarkstartown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Место, где упала чёрная звезда. Нечто из космоса сводит людей с ума.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxdarkstartown_location";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.ForceLineBattle = false;
		this.m.CombatLocation.AdditionalRadius = 10;
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxdarkstartown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Темная звезда";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_unknown_02");
}

});

