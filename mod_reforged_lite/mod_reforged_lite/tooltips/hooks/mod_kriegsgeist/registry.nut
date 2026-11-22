// Тултип-хуки mod_legendary_kriegsgeist_location_legends-russian — активы босса-призрака,
// умения Черепа (ghost_skull), эффекты и расовые навыки (часть — скрытые служебные, хук безвреден).
local scope = "mod_kriegsgeist";

::ReforgedLite.ModSkillTooltips.addSkills([
	// Активные
	"scripts/skills/actives/legend_banshee_scream",
	"scripts/skills/actives/legend_nightmare_touch_skill",
	"scripts/skills/actives/legend_nightmare_touch_zoc_skill",
	"scripts/skills/actives/mod_ghost_collect_fragment_skill",
	"scripts/skills/actives/mod_ghost_overhead_strike_skill",
	"scripts/skills/actives/mod_ghost_split_skill",
	"scripts/skills/actives/mod_ghost_swing_skill",
	"scripts/skills/actives/mod_ghost_teleport_skill",
	"scripts/skills/actives/mod_hallucinate_skill",
	"scripts/skills/actives/mod_mass_miasma_skill",
	"scripts/skills/actives/mod_mass_root_skill",
	"scripts/skills/actives/mod_mass_spawn_ghost_skill",

	// Эффекты
	"scripts/skills/effects/mod_hallucinated_effect",
	"scripts/skills/effects/mod_strong_rooted_effect",

	// Умения Черепа (копии ванильных активов — цепочка наследования защищена движком)
	"scripts/skills/ghost_skull/mod_death_skill",
	"scripts/skills/ghost_skull/mod_horror_skill",
	"scripts/skills/ghost_skull/mod_insects_skill",
	"scripts/skills/ghost_skull/mod_raise_undead_skill",
	"scripts/skills/ghost_skull/mod_spawn_ghost_skill",
	"scripts/skills/ghost_skull/mod_wither_skill",

	// Прочие
	"scripts/skills/mod_ghost_skull_magic_skill",
	"scripts/skills/special/mod_ghost_skull_XP_collecter",

	// Расовые
	"scripts/skills/racial/mod_ghastly_touch_racial",
	"scripts/skills/racial/mod_ghost_boss_stats_changer",
	"scripts/skills/racial/mod_ghost_knight_boss_racial",
	"scripts/skills/racial/mod_ghost_mage_boss_racial",
	"scripts/skills/racial/mod_illusion_racial",
], scope);
