this.xxswordtown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Чести войти удостаиваются лишь достойные.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxswordtown_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxswordtown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Зал доказательств";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_stronghold_01");
		this.getSprite("body").Color = this.createColor("#bdd1ff");
		this.addSprite("lighting").setBrush("world_stronghold_01_undead_lights");
		this.getSprite("lighting").Saturation = 1.2;
		this.getSprite("lighting").Color = this.createColor("#8a9dff");
}

});

