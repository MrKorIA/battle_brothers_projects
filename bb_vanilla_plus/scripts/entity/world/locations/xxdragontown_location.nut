this.xxdragontown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Гнездо легендарных созданий. Это очень опасное место, если хозяин гнезда всё ещё существует.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxdragontown_location";
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
		this.m.OnEnter = "event.xxdragontown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Драконье гнездо";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_unknown_02");
	this.getSprite("body").Color = this.createColor("#d43f22");
	}

});

