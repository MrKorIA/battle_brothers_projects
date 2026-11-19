::OrcArena <- {
	ID = "mod_shourenjingjichang",
	Name = "Арена Орков",
	Version = "1.0.0"
}
::OrcArena.HooksMod <- ::Hooks.register(::OrcArena.ID, ::OrcArena.Version, ::OrcArena.Name);
::OrcArena.HooksMod.require(["mod_msu"]);

::OrcArena.HooksMod.queue(">mod_msu", function() {
	::OrcArena.Mod <- ::MSU.Class.Mod(::OrcArena.ID, ::OrcArena.Version, ::OrcArena.Name);

    ::OrcArena.HooksMod.hook("scripts/ai/tactical/behaviors/ai_defend_shieldwall", function(q) {
    	q.m.PossibleSkills.push("actives.indomitable");
    });

    ::OrcArena.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function (q)
    {
        q.m.PossibleSkills.push("actives.fengzishuangfu01_01");
        q.m.PossibleSkills.push("actives.guerdanfazhang01_01");
        q.m.PossibleSkills.push("actives.zuie01_01");
        q.m.PossibleSkills.push("actives.zuie01_02");
        q.m.PossibleSkills.push("actives.niutourenkandao01_01");
        q.m.PossibleSkills.push("actives.shourenbusirendafu01_01");
        q.m.PossibleSkills.push("actives.qiuzhangquanjian01_01");
    });

    ::OrcArena.HooksMod.hook("scripts/states/world/asset_manager", function (q)
    {
//        local update = o.update;
//        q.update = function(_worldState)
        q.update = @(__original) function(_worldState)
        {
            __original(_worldState)
            if (!this.World.Flags.get("spawned_shourenjingjichang"))
            {
                local disallowedTerrain;
                local f;
                local tile;
                local camp;
                disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
                f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs)
                while (tile == null)
                {
                    tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
                }
                if (tile != null)
                {
                    camp = this.World.spawnLocation("scripts/entity/world/locations/shourenjingjichang_location", tile.Coords);
                }
                if (camp != null)
                {
                    this.logInfo("Orc Arena Spawned");
                    camp.setBanner("banner_orcs_03");
                    camp.onSpawned();
                    f.addSettlement(camp, false);
                    this.World.Flags.set("spawned_shourenjingjichang", true);
                }
            }
        }
    });

});

