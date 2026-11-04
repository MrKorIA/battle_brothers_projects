this.xxknighttown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Две великие фракции начнут здесь войну.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxknighttown_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxknighttown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Великое поле битвы";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("noble_camp_01");
		this.addSprite("lightinga").setBrush("noble_camp_01_light");
	}

});

