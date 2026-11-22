// Тултип-хуки mod_druid — активы, эффекты, перки, расовый навык (предыстория не трогается).
local scope = "mod_druid";

::ReforgedLite.ModSkillTooltips.addSkills([
	// Активные
	"scripts/skills/actives/druid_entangle",
	"scripts/skills/actives/druid_regrowth",
	"scripts/skills/actives/druid_summon_beast",

	// Эффекты
	"scripts/skills/effects/druid_beast_aura_effect",
	"scripts/skills/effects/druid_regrowth_effect",

	// Перки (дерево — scripts/!config/z_druid.nut)
	"scripts/skills/perks/perk_druid_apex",
	"scripts/skills/perks/perk_druid_beast_aura",
	"scripts/skills/perks/perk_druid_beast_rage",
	"scripts/skills/perks/perk_druid_beastform",
	"scripts/skills/perks/perk_druid_entangle",
	"scripts/skills/perks/perk_druid_hatch",
	"scripts/skills/perks/perk_druid_regrowth",
	"scripts/skills/perks/perk_druid_venom",

	// Расовый
	"scripts/skills/racial/druid_venom",
], scope);

::ReforgedLite.ModSkillTooltips.addTerms([
	// Упоминания умений в текстах перков
	{ Term = "Призыв зверя", Link = "Skill+druid_summon_beast" },
	{ Term = "Живицы", Link = "Skill+druid_regrowth_effect" },
	{ Term = "оплетающие корни", Link = "Skill+druid_entangle" },
], scope);
