::Const.FactionTrait.Actions[::Const.FactionTrait.Beasts].extend([
	"scripts/factions/actions/beasts/cp_build_direwolves_camp_action",
	"scripts/factions/actions/beasts/cp_build_ghouls_camp_action",
	"scripts/factions/actions/beasts/cp_build_hexen_camp_action",
	"scripts/factions/actions/beasts/cp_build_hyena_camp_action",
	"scripts/factions/actions/beasts/cp_build_lindwurm_camp_action",
	"scripts/factions/actions/beasts/cp_build_serpent_camp_action",
	"scripts/factions/actions/beasts/cp_build_unhold_bog_camp_action",
	"scripts/factions/actions/beasts/cp_build_unhold_camp_action",
	"scripts/factions/actions/beasts/cp_build_unhold_frost_camp_action",
	"scripts/factions/actions/beasts/cp_build_webknecht_camp_action",

	"scripts/factions/actions/beasts/cp_build_ankheg_camp_action",
	"scripts/factions/actions/beasts/cp_build_bear_camp_action",
	"scripts/factions/actions/beasts/cp_build_bloodsucker_camp_action",
	"scripts/factions/actions/beasts/cp_build_boar_camp_action",
	"scripts/factions/actions/beasts/cp_build_lion_camp_action",
	"scripts/factions/actions/beasts/cp_build_snow_wolf_camp_action",
	"scripts/factions/actions/beasts/cp_build_tiger_camp_action",
	"scripts/factions/actions/beasts/cp_build_toad_camp_action",

	// For sending out roaming parties
	"scripts/factions/actions/cp_send_beast_roamers_action",
]);

local factionTraidId = 0;
foreach (key, value in ::Const.FactionTrait)
{
	if (typeof value == "integer" && value > factionTraidId)
	{
		factionTraidId = value;
	}
}

::Const.FactionTrait.OrientalVillage <- ++factionTraidId;
::Const.FactionTrait.Actions.push([
	"scripts/factions/contracts/drive_away_nomads_action",
	"scripts/factions/contracts/roaming_beasts_desert_action",
	"scripts/factions/contracts/item_delivery_action",
	"scripts/factions/contracts/escort_caravan_action",
	"scripts/factions/contracts/hunting_serpents_action",
	"scripts/factions/contracts/hunting_sand_golems_action",
	"scripts/factions/contracts/slave_uprising_action",

	"scripts/factions/actions/add_random_situation_action",
	"scripts/factions/actions/burn_location_action",
	"scripts/factions/actions/defend_citystate_action",
	"scripts/factions/actions/receive_ship_action",
	"scripts/factions/actions/rebuild_location_action",
	"scripts/factions/actions/patrol_area_action",
	"scripts/factions/actions/send_peasants_action",
	"scripts/factions/actions/send_caravan_action",
	"scripts/factions/actions/send_ship_action",

	// New, compared to southern city states
	"scripts/factions/contracts/discover_location_action",
	"scripts/factions/contracts/return_item_action",
	"scripts/factions/contracts/investigate_cemetery_action",
	"scripts/factions/contracts/restore_location_action",
	"scripts/factions/contracts/obtain_item_action",

	// Excluded, compared to southern city states, because they are too closely tied to the holy war
	/*
		"scripts/factions/actions/send_citystate_army_action",
		"scripts/factions/actions/send_citystate_holysite_action",
		"scripts/factions/contracts/hold_chokepoint_action",
		"scripts/factions/contracts/conquer_holy_site_action",
		"scripts/factions/contracts/defend_holy_site_action",
	*/
]);

