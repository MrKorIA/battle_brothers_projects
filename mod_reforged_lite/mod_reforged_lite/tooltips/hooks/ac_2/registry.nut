// Тултип-хуки AC_2 (Animal Companions) — квирки приручённых зверей.
// Квирки показаны в панели просмотра зверя (скиллы IsHidden, в тактическом тултипе их нет);
// AC сам подавляет свой tooltip-JS при установленном mod_nested_tooltips, рендер стандартный.
// Тексты квирков тривиальны («Ярость.» и пр.) — термины не нужны.
local scope = "ac_2";

::ReforgedLite.ModSkillTooltips.addSkills([
	// Квирки (scripts/companions/quirks/, список — companions_quirks.nut)
	"scripts/companions/quirks/companions_berserker_rage",
	"scripts/companions/quirks/companions_good_boy",
	"scripts/companions/quirks/companions_healthy",
	"scripts/companions/quirks/companions_poisonous",
	"scripts/companions/quirks/companions_regenerative",
	"scripts/companions/quirks/companions_soften_blows",

	// Активы компаньонов (onequip + skills): ссылочная стоимость и термины
	"scripts/companions/onequip/companions_leash",
	"scripts/companions/onequip/companions_raise",
	"scripts/companions/onequip/companions_unleash",
	"scripts/companions/skills/companions_nightmare_skill",
	"scripts/companions/skills/companions_swallow_whole",
], scope);
