this.xxruinedtown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Нечто опасное захватило и опустошило город. Выживших нет, поэтому никто не знает, что здесь случилось.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxruinedtown_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxruinedtown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Разрушенный город";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_townhall_03_ruins");
		this.addSprite("lighting").setBrush("world_townhall_03_undead_lights");
		this.getSprite("lighting").Saturation = 1.2;
	}

});

