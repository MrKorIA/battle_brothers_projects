this.xxwolftown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Это логово опасных зверей. Тысячи костей животных и людей предупреждают нас не приходить сюда.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxwolftown_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxwolftown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Логово волков";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_unknown_01");
	}

});

