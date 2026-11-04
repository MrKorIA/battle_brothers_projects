this.xxghoultown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Занятое ядовитыми тварями и дикими монстрами, это место наполнено отвратительной вонью и гнетущей мрачностью.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxghoultown_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxghoultown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Дикий улей";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_unknown_01");
		this.getSprite("body").Color = this.createColor("#787878");
		this.getSprite("body").Saturation = 0.1;
	}

});

