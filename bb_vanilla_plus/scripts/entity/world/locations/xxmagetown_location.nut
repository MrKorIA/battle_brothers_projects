this.xxmagetown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Это таинственная башня, где обитает Король-волшебник.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxmagetown_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxmagetown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Башня волшебника";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_graveyard_01");
		this.addSprite("lightinga").setBrush("world_ancient_watchtower");
		this.getSprite("lightinga").Scale = 0.7;
		this.setSpriteOffset("lightinga", this.createVec(10, 5));
	}

});

