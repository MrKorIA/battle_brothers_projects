this.xxinfidungeon_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Искажённое злыми ритуалами, это место наполнено злобой.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.xxinfidungeon_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.xxinfidungeon_enter_event";
	}

	function onSpawned()
	{
		this.m.Name = "Бездонная яма";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonMedium
		}, false);
	}

	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_unhold_graveyard");
		this.getSprite("body").Color = this.createColor("#413d7a");
		this.getSprite("body").Saturation = 1.4;
		this.addSprite("lightinga").setBrush("world_stronghold_01_undead_lights");
	    this.getSprite("lightinga").Saturation = 1.2;
		this.addSprite("lightingb").setBrush("world_stronghold_02_undead_lights");
		this.getSprite("lightingb").Saturation = 1.2;
		this.addSprite("lightingc").setBrush("world_stronghold_03_undead_lights");
		this.getSprite("lightingc").Saturation = 1.2;
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
	}

});

