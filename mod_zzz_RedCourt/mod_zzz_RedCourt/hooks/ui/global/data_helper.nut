if (!("DynamicPerks" in getroottable()) || typeof ::DynamicPerks == "string") {
    if (!("DynamicPerks" in getroottable()))
        ::DynamicPerks <- "vampire_placeholder"; // needed to fool mod_plan_perks

    ::Hooks.registerJS("ui/mods/vampire.js");
    ::Hooks.registerCSS("ui/mods/vampire.css");

    ::TheRedCourt.HooksMod.hook("scripts/ui/global/data_helper", function (q) {

        q.convertEntityToUIData = @(__original) function(_entity, _activeEntity) {
            local result = __original(_entity, _activeEntity);
            local isVampire = _entity != null;
            if (isVampire)
            {
                isVampire = _entity.getSkills().hasSkill("background.hemovore_avatar")
                        || _entity.getSkills().hasSkill("background.hemovore_magic")
                        || _entity.getSkills().hasSkill("background.hemovore_HIGH")
                        || _entity.getSkills().hasSkill("background.hemovore_MED")
                        || _entity.getSkills().hasSkill("background.hemovore_LOW");
            }

            if (isVampire) {

                local allowedMasteries = {};
                foreach (w in ["cleaver" "axe" "sword" "dagger" "polearm" "spear"])
                    allowedMasteries["perk.mastery." + w] <- true;
                local forbiddenPerks = {};
                foreach (w in ["nimble" "hackflows.stabilized" "battle_forged"])
                    forbiddenPerks["perk." + w] <- true;

                local perks = ::Const.Perks.Perks.map(@(row) clone row);
                perks[3] = perks[3].filter(@(_, p) p.ID in allowedMasteries);
                if (_entity.getSkills().hasSkill("background.hemovore_magic"))
                {
                    forbiddenPerks["perk.berserk"] <- true;
                    perks[6] = perks[6].filter(@(_, p) p.ID != "perk.killing_frenzy");
                }
                perks[5] = perks[5].filter(@(_, p) !(p.ID in forbiddenPerks));

                foreach (perk in ::Const.Perks.Vampire) {
                    perks[perk.Row].push(perk);
                }
                if (_entity.getSkills().hasSkill("background.hemovore_magic"))
                {
                    foreach (perk in ::Const.Perks.HemovoreMagic) {
                        perks[perk.Row].push(perk);
                    }
                }
                result.vampire_perkTree <- perks;
            }
            return result;
        }
    });
}