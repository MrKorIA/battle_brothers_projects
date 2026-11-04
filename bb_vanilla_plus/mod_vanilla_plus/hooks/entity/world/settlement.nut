::VanillaPlus.QueueBucket.VeryLate.push(function() {
	::VanillaPlus.HooksMod.hookTree("scripts/entity/world/settlement", function (q) {
        local numPiro = 0;
        local numCrio = 0;
        local numElectro = 0;
        local numRonin = 0;
        local numNindja = 0;
        local numShaman = 0;
        local numDemon = 0;
//        local numVestal = 0;

        //add vp_piro_background
        if (q.ClassName.find("city_state") != null) numPiro = 2;

        //add vp_crio_background
        if (q.ClassName.find("_tundra_") != null || q.ClassName.find("_snow_") != null) numCrio += 1;
        if (q.ClassName.find("_coast_") != null || q.ClassName.find("_fishing_") != null) numCrio += 1;
        if (q.ClassName.find("large_") != null) numCrio += 1;

        //add vp_electro_background
        if (q.ClassName.find("_fort") != null)
        {
          numElectro += 1;
          if (q.ClassName.find("medium_") != null) numElectro += 1;
          if (q.ClassName.find("large_") != null) numElectro += 2;
        }

        //add vp_ronin_background
        if (q.ClassName.find("_farming_") != null || q.ClassName.find("_steppe_") != null || q.ClassName.find("_fishing_") != null)
        {
            if (q.ClassName.find("small_") != null && q.ClassName.find("_village") != null) numRonin = 1;
        }
        if (q.ClassName.find("_southern_village") != null) numRonin = 1;

        //add vp_nindja_background
        if (q.ClassName.find("large_") != null && q.ClassName.find("_village") != null) numNindja = 1;

        //add vp_demon_background
        if (q.ClassName.find("small_") != null) numDemon = 1;
        if (q.ClassName.find("_swamp_") != null) numDemon += 1;

        //add vp_shaman_background
        if (q.ClassName.find("forest_") != null) numShaman = 2;
        if (q.ClassName.find("_swamp_") != null) numShaman = 1;
        if (q.ClassName.find("_lumber_") != null) numShaman = 1;
        if (q.ClassName.find("_tundra_") != null) numShaman = 1;
        if (q.ClassName.find("_snow_") != null) numShaman = 1;

        q.create = @(__original) function () {
            __original();
            for (local i = 0; i < numPiro; i++)
            {
                this.m.DraftList.push("vp_piro_background");
            }
            for (local i = 0; i < numCrio; i++)
            {
                this.m.DraftList.push("vp_crio_background");
            }
            for (local i = 0; i < numElectro; i++)
            {
                this.m.DraftList.push("vp_electro_background");
            }
//            for (local i = 0; i < numRonin; i++)
//            {
//              this.m.DraftList.push("vp_ronin_background");
//            }
//            for (local i = 0; i < numNindja; i++)
//            {
//              this.m.DraftList.push("vp_nindja_background");
//            }
            for (local i = 0; i < numShaman; i++)
            {
                this.m.DraftList.push("vp_shaman_background");
            }
            for (local i = 0; i < numDemon; i++)
            {
                this.m.DraftList.push("vp_demon_background");
            }

        };

        q.addBuilding = @(__original) function( _building, _slot = null )
        {
            __original(_building, _slot);
            if (!this.isSouthern() && _building.getID() == "building.temple")
            {
                this.m.DraftList.push("vp_vestal_background");
            }
        }

        q.onUpdateShopList = @(__original) function( _id, _list )
        {
            if (_list != null)
            {
                switch (_id)
                {
                    case "building.alchemist":
                    {
                        _list.push({
                            R = 75,
                            P = 1.0,
                            S = "accessory/cp_vulture_item",
                        });

                        _list.push({
                            R = 75,
                            P = 1.0,
                            S = "accessory/cp_owl_item",
                        });

                        break;
                    }

                    case "building.marketplace":
                    {
                        if (this.getSize() >= 3 || this.isMilitary())
                        {
                            _list.push({
                                R = 95,
                                P = 1.0,
                                S = "accessory/cp_hawk_item",
                            });

                            _list.push({
                                R = 95,
                                P = 1.0,
                                S = "accessory/cp_owl_item",
                            });

                            _list.push({
                                R = 95,
                                P = 1.0,
                                S = "accessory/cp_vulture_item",
                            });
                        }

                        if (this.isSouthern())
                        {
                            _list.push({
                              R = 40,
                              P = 1.0,
                              S = "weapons/cp_reinforced_wooden_staff",
                            });

                            // Being made of wood, torches are a bit rarer in southern settlements
                            _list.push({
                                R = 30,
                                P = 1.5,
                                S = "tools/cp_wooden_torch",
                            });
                        }
                        else
                        {
                            _list.push({
                              R = 40,
                              P = 1.0,
                              S = "tools/bear_trap_item",
                            });
                            _list.push({
                                R = 10,
                                P = 1.0,
                                S = "tools/cp_wooden_torch",
                            });
                            _list.push({
                                R = 20,
                                P = 1.0,
                                S = "armor_upgrades/xxcape_upgrade",
                            });
                        }
                    }
                }

                __original(_id, _list);
            }
        }
    });
});

