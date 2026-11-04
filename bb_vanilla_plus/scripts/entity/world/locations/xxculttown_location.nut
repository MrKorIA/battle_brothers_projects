this.xxculttown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Деревня, занятая культистами Давкула.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxculttown_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxculttown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Убежище культистов";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_townhall_02_undead");
		this.addSprite("lightinga").setBrush("world_townhall_02_undead_lights");
	}

});

