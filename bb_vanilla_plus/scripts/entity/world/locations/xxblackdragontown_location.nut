this.xxblackdragontown_location <- this.inherit("scripts/entity/world/location", {
	function getDescription()
	{
		return "Злобная сущность собирает здесь армию, чтобы уничтожить человечество.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxblackdragontown_location";
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
		this.m.OnEnter = "event.xxblackdragontown_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Гнездо Черного Дракона";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_unknown_02");
	this.getSprite("body").Color = this.createColor("#888894");
		this.getSprite("body").Saturation = 0.1;
	}

});

