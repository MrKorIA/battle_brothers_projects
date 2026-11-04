::Wushi <- {
	ID = "mod_wushi",
	Name = "Самураи",
	Version = "1.0.0"
}
::Wushi.HooksMod <- ::Hooks.register(::Wushi.ID, ::Wushi.Version, ::Wushi.Name);
::Wushi.HooksMod.require(["mod_msu"]);

::Wushi.HooksMod.queue(">mod_msu", ">mod_fantasybro", function() {
	::Wushi.Mod <- ::MSU.Class.Mod(::Wushi.ID, ::Wushi.Version, ::Wushi.Name);

	::Wushi.HooksMod.hook("scripts/factions/faction_manager", function(q) {
    	q.createWushiFaction <- { function createWushiFaction()
    	{
    		local wushi_faction = ::new("scripts/factions/wushi_faction");
    		wushi_faction.setID(this.m.Factions.len());
    		wushi_faction.setName("Самураи");
    		wushi_faction.setDiscovered(true);
    		wushi_faction.addTrait(::Const.FactionTrait.Wushi);
    		this.m.Factions.push(wushi_faction);
    	}}.createWushiFaction;

    	q.createZhujiancunFaction <- { function createZhujiancunFaction()
    	{
    		local zhujiancun_faction = ::new("scripts/factions/zhujiancun_faction");
    		zhujiancun_faction.setID(this.m.Factions.len());
    		zhujiancun_faction.setName("Обитель изгоев");
    		zhujiancun_faction.setDiscovered(true);
    		zhujiancun_faction.addTrait(::Const.FactionTrait.Zhujiancun);
    		this.m.Factions.push(zhujiancun_faction);
    	}}.createZhujiancunFaction;

    	q.createAlliances = @(__original) { function createAlliances()
    	{
    		this.createWushiFaction();
    		this.createZhujiancunFaction();

    		__original();

    	}}.createAlliances;

    	q.runSimulation = @(__original) { function runSimulation()
    	{
    		local wushi_faction = this.getFactionOfType(::Const.FactionType.Wushi);
    		local ping = this.__ping;
    		this.__ping = function()
    		{
    			wushi_faction.update(true, true);
    			ping();
    		}
    		__original();
    		this.__ping = ping;
    	}}.runSimulation;

    });

    ::MSU.Table.merge(::Const.Music, {
        WushiTracks = [
            "music/wushi.ogg"
        ]
    });

    ::Wushi.HooksMod.hook("scripts/ai/tactical/behaviors/ai_darkflight", function(q) {
    	q.m.PossibleSkills.push("actives.tudun");
    });

    ::Wushi.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function(q) {
		q.m.PossibleSkills.push("actives.wushiweapon03_01");
		q.m.PossibleSkills.push("actives.wushiweapon04_01");
		q.m.PossibleSkills.push("actives.wushiweapon05_01");
		q.m.PossibleSkills.push("actives.wushiweapon05_02");
		q.m.PossibleSkills.push("actives.wushiweapon08_01");
		q.m.PossibleSkills.push("actives.wushiweapon22_01");
		q.m.PossibleSkills.push("actives.wushiweapon19_01");
		q.m.PossibleSkills.push("actives.wushiweapon25_01");
		q.m.PossibleSkills.push("actives.wushiweapon32_01");
		q.m.PossibleSkills.push("actives.wushiweapon32_02");
		q.m.PossibleSkills.push("actives.wushiweapon39_01");
    });

    ::Wushi.HooksMod.hook("scripts/ai/tactical/behaviors/ai_engage_melee", function(q) {
    	q.m.PossibleSkills.push("actives.wushiweapon39_02");
    });

	::Wushi.HooksMod.hookTree("scripts/entity/world/settlement", function (q) {
        local numRonin = 0;
        local numNindja = 0;
        local numJianhao = 0;

        //add vp_ronin_background
        if (q.ClassName.find("_farming_") != null || q.ClassName.find("_steppe_") != null || q.ClassName.find("_fishing_") != null)
        {
            if (q.ClassName.find("small_") != null && q.ClassName.find("_village") != null) numRonin = 1;
        }
        if (q.ClassName.find("_southern_village") != null) numRonin = 1;

        //add vp_nindja_background
        if (q.ClassName.find("large_") != null && q.ClassName.find("_village") != null) numNindja = 1;

        //add Jianhao
        if (q.ClassName.find("large_") != null && q.ClassName.find("_village") != null) numJianhao = 1;
        if (q.ClassName.find("city_state") != null) numJianhao = 1;

        q.create = @(__original) function () {
            __original();
            for (local i = 0; i < numRonin; i++)
            {
              this.m.DraftList.push("langren_background");
            }
            for (local i = 0; i < numNindja; i++)
            {
              this.m.DraftList.push("renzhe_background");
            }
            for (local i = 0; i < numJianhao; i++)
            {
              this.m.DraftList.push("jianhao_background");
            }
        };

    });

    ::mods_hookNewObjectOnce("states/world/asset_manager", function (o)
    {
    		local update = o.update;
    		o.update = function(_worldState)
    		{
    			update(_worldState)
    			if (!this.World.Flags.get("spawned_zhujiancun"))
    			{
                    local disallowedTerrain;
                    local f;
                    local tile;
                    local camp;
                    local mTile;
                    local mTile;
                    local tries = 0;
    				disallowedTerrain = [::Const.World.TerrainType.Mountains, ::Const.World.TerrainType.Impassable, ::Const.World.TerrainType.Forest, ::Const.World.TerrainType.AutumnForest, ::Const.World.TerrainType.SnowyForest, ::Const.World.TerrainType.LeaveForest, ::Const.World.TerrainType.Ocean, ::Const.World.TerrainType.Shore];

    				local mountainsTerrain = [];
                    for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                    {
                        if (i == ::Const.World.TerrainType.Mountains)
                        {
                            continue;
                        }
                        mountainsTerrain.push(i);
                    }

                    local mapSize = this.World.getMapSize();
                    local mountainTiles = [];

                    local yStart = this.Math.floor(mapSize.Y * 0.2);
                    local yEnd   = this.Math.floor(mapSize.Y * 0.65);

                    for (local x = 1; x < mapSize.X; ++x)
                    {
                        for (local y = yStart; y < yEnd; ++y)
                        {
                            if (!this.World.isValidTile(x, y)) continue;

                            local t = this.World.getTile(x, y);
                            if (t != null && t.Type == this.Const.World.TerrainType.Mountains)
                            {
                                mountainTiles.push(t);
                            }
                        }
                    }

                    if (mountainTiles.len() == 0)
                    {
                        this.logInfo("NO MOUNTAINS FOUND!");
                        return;
                    }

                    while (tile == null)
                    {
                        this.logInfo("iteration while tile");

                        local mTile = mountainTiles[this.Math.rand(0, mountainTiles.len() - 1)];

                        local minRadius = 1;
                        local maxRadius = 6;
                        local validTiles = [];

                        for (local r = minRadius; r <= maxRadius; r = ++r)
                        {
                            local currentTile = mTile;
                            for (local i = 0; i < r; i = ++i)
                            {
                                if (currentTile != null && currentTile.hasNextTile(0))
                                    currentTile = currentTile.getNextTile(0);
                                else
                                {
                                    currentTile = null;
                                    break;
                                }
                            }

                            if (currentTile == null) continue;

                            local directions = [2, 3, 4, 5, 0, 1];

                            foreach (dir in directions)
                            {
                                for (local step = 0; step < r; step = ++step)
                                {
                                    if (currentTile == null) break;

                                    local isValid = true;

                                    if (disallowedTerrain.find(currentTile.Type) != null) isValid = false;
                                    if (currentTile.IsOccupied || currentTile.HasRoad || currentTile.HasRiver) isValid = false;

                                    local settlements = this.World.EntityManager.getSettlements();
                                    foreach (s in settlements)
                                    {
                                        if (s.getTile().getDistanceTo(currentTile) <= 3)
                                        {
                                            isValid = false;
                                            break;
                                        }
                                    }

                                    if (isValid)
                                    {
                                        local distance = mTile.getDistanceTo(currentTile);
                                        local score = 1000 - distance;

                                        if (currentTile.Type == this.Const.World.TerrainType.Plains)
                                            score += 50;

                                        validTiles.push({ Tile = currentTile, Score = score });
                                    }

                                    if (currentTile.hasNextTile(dir))
                                        currentTile = currentTile.getNextTile(dir);
                                    else
                                    {
                                        currentTile = null;
                                        break;
                                    }
                                }

                                if (currentTile == null) break;
                            }
                        }

                        if (validTiles.len() > 0)
                        {
                            local bestScore = -999999;
                            local bestTile = null;

                            foreach (item in validTiles)
                            {
                                if (item.Score > bestScore)
                                {
                                    bestScore = item.Score;
                                    bestTile = item.Tile;
                                }
                            }

                            tile = bestTile;
                        }
                    }

    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/settlements/zhujiancun", tile.Coords);
    					this.World.uncoverFogOfWar(camp.getTile().Pos, 1200);
    					camp.setDiscovered(true);
    				}
    				if (camp != null)
    				{
    					camp.setBanner("zhujiancun_01");
    					camp.onSpawned();
                        f = this.World.FactionManager.getFactionOfType(::Const.FactionType.Zhujiancun);
                        f.addPlayerRelation(1.0, "Увидел цветение сакуры");
    					f.addSettlement(camp, true);
    					this.World.Flags.set("spawned_zhujiancun", true);

    					this.logInfo("spawned_zhujiancun Here");
    				}
    			}
    		}
    });

});
