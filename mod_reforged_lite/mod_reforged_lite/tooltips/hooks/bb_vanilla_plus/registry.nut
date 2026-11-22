// Тултип-хуки bb_vanilla_plus — ТОЛЬКО перки из деревьев перков (scripts/config/z_*.nut).
// Остальные навыки bb_vanilla_plus по задаче не трогаем (но они могут быть ЦЕЛЯМИ ссылок).
// Термины: названия магических умений из текста перка «Мастерство маны»
// («Улучшаемые навыки: …») — ссылки на активные навыки bb_vanilla_plus.
local scope = "bb_vanilla_plus";

::ReforgedLite.ModSkillTooltips.addSkills([
	// Перки из конфигов деревьев (scripts/config/z_*.nut)
	"scripts/skills/perks/perk_vp_blessing",
	"scripts/skills/perks/perk_vp_bloodletting",
	"scripts/skills/perks/perk_vp_bloodlust",
	"scripts/skills/perks/perk_vp_counter",
	"scripts/skills/perks/perk_vp_demon",
	"scripts/skills/perks/perk_vp_drainblood",
	"scripts/skills/perks/perk_vp_frenzy",
	"scripts/skills/perks/perk_vp_heal",
	"scripts/skills/perks/perk_vp_maso",
	"scripts/skills/perks/perk_vp_miracle",
	"scripts/skills/perks/perk_vp_pull",
	"scripts/skills/perks/perk_vp_shieldf",
	"scripts/skills/perks/perk_vp_sumfiend",
	"scripts/skills/perks/perk_vp_xx05",
	"scripts/skills/perks/perk_vp_xx07",
	"scripts/skills/perks/perk_vp_xx19",
	"scripts/skills/perks/perk_vp_xx41",
	"scripts/skills/perks/perk_vp_xx57",
	"scripts/skills/perks/perk_vp_xx74",
	"scripts/skills/perks/perk_vp_xx75",
	"scripts/skills/perks/perk_vp_xx80",
	"scripts/skills/perks/perk_vp_xx81",
	"scripts/skills/perks/perk_vp_xx82",
	"scripts/skills/perks/perk_vp_xxp09",
	"scripts/skills/perks/perk_vp_xxp12",
	"scripts/skills/perks/perk_vp_xxp25",
	"scripts/skills/perks/perk_vp_xxp26",
], scope);

::ReforgedLite.ModSkillTooltips.addTerms([
	{ Term = "Огненный шар", Link = "Skill+sb_fireball_skill" },
	{ Term = "Пламенная волна", Link = "Skill+sb_flamewave_skill" },
	{ Term = "Армагеддон", Link = "Skill+sbq6_bigfire_skill" },
	{ Term = "Электрический шок", Link = "Skill+sb_electric_skill" },
	{ Term = "Гроза", Link = "Skill+sb_manaforce_skill" },
	{ Term = "Шаровая Молния", Link = "Skill+sb_pull_skill" },
	{ Term = "Штормовая сила", Link = "Skill+sb_gale_skill" },
	{ Term = "Ледяной Взрыв", Link = "Skill+sb_frostblast_skill" },
], scope);
