// Тултип-хуки mod_Retired_Gladiator-russian — активы, эффекты, перки (предыстории не трогаются).
local scope = "mod_retired_gladiator";

::ReforgedLite.ModSkillTooltips.addSkills([
	// Активные
	"scripts/skills/actives/retglad_stoic",

	// Эффекты
	"scripts/skills/effects/crippled_effect",
	"scripts/skills/effects/female_voice_effect",
	"scripts/skills/effects/retglad_stoic_effect",

	// Перки (описания — Const.Strings.PerkDescription.* в scripts/config/)
	"scripts/skills/perks/perk_legend_throw_sand",
	"scripts/skills/perks/perk_retglad_mentor",
	"scripts/skills/perks/perk_retglad_path",
	"scripts/skills/perks/perk_retglad_precise_strikes",
	"scripts/skills/perks/perk_retglad_rapid_advance",
	"scripts/skills/perks/perk_retglad_stoic",
], scope);

::ReforgedLite.ModSkillTooltips.addTerms([
	// Эффект «Калека» в тексте перка «Точные удары»
	{ Term = "Калека", Link = "Skill+crippled_effect" },
], scope);
