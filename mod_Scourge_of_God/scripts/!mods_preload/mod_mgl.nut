::IronHorde <- {
	ID = "mod_mgl",
	Name = "Железная Орда",
	Version = "1.0.0"
}
::IronHorde.HooksMod <- ::Hooks.register(::IronHorde.ID, ::IronHorde.Version, ::IronHorde.Name);
::IronHorde.HooksMod.require(["mod_msu"]);

::IronHorde.HooksMod.queue(">mod_msu", function() {
	::IronHorde.Mod <- ::MSU.Class.Mod(::IronHorde.ID, ::IronHorde.Version, ::IronHorde.Name);

	::IronHorde.HooksMod.hook("scripts/factions/faction_manager", function(q) {
    	q.createIronHordeFaction <- { function createIronHordeFaction()
    	{
    		local mgl_faction = ::new("scripts/factions/mgl_faction");
    		mgl_faction.setID(this.m.Factions.len());
    		mgl_faction.setName("Железная Орда");
    		mgl_faction.setDiscovered(true);
    		mgl_faction.addTrait(::Const.FactionTrait.Mgl);
    		this.m.Factions.push(mgl_faction);
    	}}.createIronHordeFaction;

    	q.createAlliances = @(__original) { function createAlliances()
    	{
    		this.createIronHordeFaction();

    		__original();

    	}}.createAlliances;

    	q.runSimulation = @(__original) { function runSimulation()
    	{
    		local mgl_faction = this.getFactionOfType(::Const.FactionType.Mgl);
    		local ping = this.__ping;
    		this.__ping = function()
    		{
    			mgl_faction.update(true, true);
    			ping();
    		}
    		__original();
    		this.__ping = ping;
    	}}.runSimulation;

    });

    ::MSU.Table.merge(::Const.Music, {
        MglTracks = [
            "music/mgl.ogg"
        ]
    });

    ::IronHorde.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_bow", function(q) {
    	q.m.PossibleSkills.push("actives.mgl_13_01");
    	q.m.PossibleSkills.push("actives.mgl_13_02");
    });

    ::IronHorde.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function(q) {
    	q.m.PossibleSkills.push("actives.cunmin01");
    	q.m.PossibleSkills.push("actives.cunmin02");
    	q.m.PossibleSkills.push("actives.lingmu01_01");
    	q.m.PossibleSkills.push("actives.wang01_03");
    });

    ::IronHorde.HooksMod.hook("scripts/ai/tactical/behaviors/ai_gruesome_feast", function(q) {
    	q.m.PossibleSkills.push("actives.wang01_01");
    });

    ::IronHorde.HooksMod.hook("scripts/ai/tactical/behaviors/ai_warcry", function(q) {
    	q.m.PossibleSkills.push("actives.wang01_02");
    });

    ::IronHorde.HooksMod.hook("scripts/events/event_manager", function(q) {
    	q.create = @(__original) { function create()
    	{
    		__original();
    		this.addSpecialEvent("event.mgl_warning_on_road");
    	}}.create;
    });

	::IronHorde.HooksMod.hook("scripts/factions/actions/build_unique_locations_action", function(q)
	{
		q.m.BuildLegendaryKhanLocation <- true;

		q.updateBuildings = @(__original) function()
		{
			local locations = ::World.EntityManager.getLocations();

			foreach( v in locations )
			{
				if (v.getTypeID() == "location.legendary_khan_location")
				{
					this.m.BuildLegendaryKhanLocation = false;
				}
			}

			__original();
		};

		q.onExecute = @(__original) function( _faction )
		{
			if (this.m.BuildLegendaryKhanLocation)
			{
				local lair;
    			local disallowedTerrain = [];
                for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                {
                    if (i == ::Const.World.TerrainType.Steppe || i == ::Const.World.TerrainType.Badlands)
                    {
                        continue;
                    }
                    disallowedTerrain.push(i);
                }
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowedTerrain, 5, 11, 1000, 7, 7, null, ::Const.DLC.Desert ? 0.2 : 0.0);

				if (tile != null)
				{
					lair = ::World.spawnLocation("scripts/entity/world/locations/mods/mod_legendary_khan_location", tile.Coords);
				}

				if (lair != null)
				{
					lair.onSpawned();
				}
			}
			else
			{
				__original(_faction);
			}
		};
	});

});