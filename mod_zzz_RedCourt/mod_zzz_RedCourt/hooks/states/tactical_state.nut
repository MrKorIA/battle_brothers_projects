::TheRedCourt.HooksMod.hook("scripts/states/tactical_state", function(q) {

    q.gatherLoot = @(__original) function () {
        local zombieSalvage = 10;
        local zombieLoot = false;

        local EntireCompanyRoster = this.World.getPlayerRoster().getAll();
        foreach (bro in EntireCompanyRoster)
        {
            if (!bro.isAlive())
            {
                continue;
            }

            switch (bro.getBackground().getID())
            {
                case "background.hemovore_magic":
                    zombieSalvage += 5;
                break;
            }

            if (bro.getSkills().hasSkill("perk.legend_reclamation"))
            {
                zombieSalvage += 20;
            }

            if (bro.getSkills().hasSkill("perk.legend_spawn_zombie_low") || bro.getSkills().hasSkill("perk.legend_spawn_zombie_med") || bro.getSkills().hasSkill("perk.legend_spawn_zombie_high"))
            {
                zombieLoot = true;
            }
        }

        if (zombieLoot)
        {
            local loot = [];
            local size = this.Tactical.getMapSize();

            for( local x = 0; x < size.X; x = ++x )
            {
                for( local y = 0; y < size.Y; y = ++y )
                {
                    local tile = this.Tactical.getTileSquare(x, y);

                    if (tile.Properties.has("Corpse"))
                    {
                        if (tile.Properties.get("Corpse").IsResurrectable)
                        {
                            if (this.Math.rand(1, 100) <= zombieSalvage)
                            {
                                this.m.CombatResultLoot.add(this.new("scripts/items/misc/legend_zombie_item"));
                            }
                        }
                    }
                }
            }

        }

        __original();
    }
});