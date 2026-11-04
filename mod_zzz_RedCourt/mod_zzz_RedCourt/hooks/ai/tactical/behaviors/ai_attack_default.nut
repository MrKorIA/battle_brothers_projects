::TheRedCourt.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function(q) {
    q.m.PossibleSkills.push("actives.legend_heartseeker");
    q.m.PossibleSkills.push("actives.legend_scythe_cleave");
});