// Тултип-хуки zmod_davkul_rising-russian — активы, эффекты, черты культистов Давкула.
local scope = "zmod_davkul_rising";

::ReforgedLite.ModSkillTooltips.addSkills([
	// Активные
	"scripts/skills/actives/catch_enemy_skill",
	"scripts/skills/actives/mod_dark_chant",
	"scripts/skills/actives/rattle_skill",
	"scripts/skills/actives/sacrifice_ally_skill",
	"scripts/skills/actives/sling_heavy_stone_skill",
	"scripts/skills/actives/strike_mancatcher_skill",
	"scripts/skills/actives/summon_reinforcements_skill",

	// Эффекты
	"scripts/skills/effects/catching_enemy_effect",
	"scripts/skills/effects/caught_effect",
	"scripts/skills/effects/mindcontrolled_effect",
	"scripts/skills/effects/sacrificed_effect",
	"scripts/skills/effects/sacrificed_effect_enemy",
	"scripts/skills/effects/sacrificed_effect_enlightened",

	// Черты
	"scripts/skills/traits/fear_cultists_trait",
	"scripts/skills/traits/hate_cultists_trait",
], scope);
