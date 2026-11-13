// Крепости разбойников Reforged: добавляем action строительства в список действий
// ванильной фракции бандитов (конкурирует с ванильным build_bandit_camp_action, как в оригинале)
::Const.FactionTrait.Actions[::Const.FactionTrait.Bandit].extend([
	"scripts/factions/actions/rf_build_bandit_camp_action"
]);
