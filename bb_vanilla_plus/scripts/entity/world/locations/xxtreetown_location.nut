this.xxtreetown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Это дерево, больше любого замка, подобно мифическому существу.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxtreetown_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxtreetown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Древо жизни";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_tundra_location");
		this.getSprite("body").Color = this.createColor("#9ecf84");
	}

});

