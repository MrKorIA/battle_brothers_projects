this.shourenjingjichang_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Огромное роскошное здание. Странно, но оттуда доносятся вопли орков.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.shourenjingjichang_location";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.CombatLocation.Template[0] = "tactical.shourenjingjichang_floor";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.AdditionalRadius = 10;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.shourenjingjichang_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Арена орков";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
	    this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_holy_site_02");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
	}

});

