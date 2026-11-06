::VanillaPlus.HooksMod.hook("scripts/ui/global/data_helper", function (q) {
    ::DynamicPerks <- "necro_placeholder";

    q.convertEntityToUIData = @(__original) function(_entity, _activeEntity) {
        // Получаем стандартные данные интерфейса
        local result = __original(_entity, _activeEntity);

        local allowedMasteries = {};
        foreach (w in ["mace" "cleaver" "sword" "dagger" "polearm" "crossbow" "throwing"])
            allowedMasteries["perk.mastery." + w] <- true;

        if (_entity != null && _entity.getSkills().hasSkill("vp.piro.background"))
        {
            local perks = ::Const.Perks.Perks.map(@(row) clone row);
            perks[2] = perks[2].filter(@(_, p) p.ID != "perk.taunt");
            perks[3] = perks[3].filter(@(_, p) p.ID in allowedMasteries);
            perks[5] = perks[5].filter(@(_, p) p.ID != "perk.berserk");
            perks[5] = perks[5].filter(@(_, p) p.ID != "perk.battle_forged");
            perks[6] = perks[6].filter(@(_, p) p.ID != "perk.killing_frenzy");

            foreach (perk in ::Const.Perks.Piro) {
                perks[perk.Row].push(perk);
            }
            result.vp_perkTree <- perks;
        }
        else if (_entity != null && _entity.getSkills().hasSkill("vp.crio.background"))
        {
            local perks = ::Const.Perks.Perks.map(@(row) clone row);
            perks[2] = perks[2].filter(@(_, p) p.ID != "perk.taunt");
            perks[3] = perks[3].filter(@(_, p) p.ID in allowedMasteries);
            perks[5] = perks[5].filter(@(_, p) p.ID != "perk.berserk");
            perks[5] = perks[5].filter(@(_, p) p.ID != "perk.battle_forged");
            perks[6] = perks[6].filter(@(_, p) p.ID != "perk.killing_frenzy");

            foreach (perk in ::Const.Perks.Crio) {
                perks[perk.Row].push(perk);
            }
            result.vp_perkTree <- perks;
        }
        else if (_entity != null && _entity.getSkills().hasSkill("vp.electro.background"))
        {
            local perks = ::Const.Perks.Perks.map(@(row) clone row);
            perks[2] = perks[2].filter(@(_, p) p.ID != "perk.taunt");
            perks[3] = perks[3].filter(@(_, p) p.ID in allowedMasteries);
            perks[5] = perks[5].filter(@(_, p) p.ID != "perk.berserk");
            perks[5] = perks[5].filter(@(_, p) p.ID != "perk.battle_forged");
            perks[6] = perks[6].filter(@(_, p) p.ID != "perk.killing_frenzy");

            foreach (perk in ::Const.Perks.Electro) {
                perks[perk.Row].push(perk);
            }
            result.vp_perkTree <- perks;
        }
        else if (_entity != null && _entity.getSkills().hasSkill("vp.vestal.background"))
        {
            local perks = ::Const.Perks.Perks.map(@(row) clone row);
            local allowedShamanMasteries = {};
            foreach (w in ["mace" "hammer" "flail" "sword" "spear" "polearm"])
            perks[3] = perks[3].filter(@(_, p) p.ID in allowedMasteries);
            perks[5] = perks[5].filter(@(_, p) p.ID != "perk.berserk");
            perks[6] = perks[6].filter(@(_, p) p.ID != "perk.killing_frenzy");

            foreach (perk in ::Const.Perks.Vestal) {
                perks[perk.Row].push(perk);
            }
            result.vp_perkTree <- perks;
        }
        else if (_entity != null && _entity.getSkills().hasSkill("vp.demon.background"))
        {
            local perks = ::Const.Perks.Perks.map(@(row) clone row);
            local allowedShamanMasteries = {};
            foreach (w in ["mace" "hammer" "cleaver" "flail" "axe" "sword" "dagger" "polearm" "crossbow" "throwing"])
                allowedShamanMasteries["perk.mastery." + w] <- true;
            perks[3] = perks[3].filter(@(_, p) p.ID in allowedMasteries);

            foreach (perk in ::Const.Perks.Demon) {
                // Clone so the per-entity demon_blocked flag never leaks onto the shared perk definition.
                local p = clone perk;
                delete p.verifyPrerequisites;
                p.demon_blocked <- ::Const.Demon.isPerkBlocked(perk.ID, _entity.getSkills());
                perks[perk.Row].push(p);
            }
            result.vp_perkTree <- perks;
        }
        else if (_entity != null && _entity.getSkills().hasSkill("vp.shaman.background"))
        {
            local perks = ::Const.Perks.Perks.map(@(row) clone row);
            local allowedShamanMasteries = {};
            foreach (w in ["mace" "hammer" "axe" "spear" "polearm" "throwing"])
                allowedShamanMasteries["perk.mastery." + w] <- true;
            perks[2] = perks[2].filter(@(_, p) p.ID != "perk.taunt");
            perks[3] = perks[3].filter(@(_, p) p.ID in allowedShamanMasteries);
            perks[5] = perks[5].filter(@(_, p) p.ID != "perk.battle_forged");

            foreach (perk in ::Const.Perks.Shaman) {
                perks[perk.Row].push(perk);
            }
            result.vp_perkTree <- perks;
        }

        return result;
    }
});