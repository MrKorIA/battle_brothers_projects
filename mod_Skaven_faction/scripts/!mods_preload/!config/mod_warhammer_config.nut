::Const.ProjectileType.PlagueGlobe <- ::Const.ProjectileType.COUNT;
::Const.ProjectileType.COUNT = ::Const.ProjectileType.COUNT + 1;

::Const.ProjectileSprite.push("rat_projectile_01");

local highest = 0;
foreach (v in ::Const.FactionTrait)
{
	if (typeof v == "integer" && v > highest)
	{
		highest = v;
	}
}

local function addFaction( _key, _color, _base, _actions, _battleTracks )
{
	::Const.FactionType[_key] <- ::Const.FactionType.COUNT;
	::Const.FactionType.COUNT++;

	::Const.Faction[_key] <- ::Const.Faction.COUNT;
	::Const.Faction.COUNT++;

	::Const.FactionColor.push(_color);

	::Const.FactionBase.push(_base);

	::Const.FactionTrait[_key] <- ++highest;
	::Const.FactionTrait.Actions.push(_actions);

	::Const.Music.BattleTracks.push(_battleTracks);
}

addFaction(
	"Rat",
	::createColor("#ff9595"),
	"bust_base_rat",
	[
		"scripts/factions/actions/build_rat_camp_action",
		"scripts/factions/actions/send_rat_ambushers_action",
		"scripts/factions/actions/send_rat_roamers_action",
		"scripts/factions/actions/defend_rat_action"
	],
	[
		"music/rat.ogg"
	]
);

addFaction(
	"RatBeast",
	::createColor("#b75a00"),
	"bust_base_rat",
	[
		"scripts/factions/actions/send_rat_beast_roamers_action"
	],
	[
		"music/rat.ogg"
	]
);

::Const.FactionAlliance.push([
    ::Const.Faction.Rat,
    ::Const.Faction.RatBeast
]);

::Const.FactionAlliance.push([
    ::Const.Faction.RatBeast,
    ::Const.Faction.Rat
]);

::Const.RatBanners <- [
	"banner_rat_01",
	"banner_rat_02",
	"banner_rat_03",
	"banner_rat_04",
	"banner_rat_05",
	"banner_rat_06",
	"banner_rat_07",
	"banner_rat_08",
	"banner_rat_09",
	"banner_rat_10",
	"banner_rat_11",
	"banner_rat_12"
];

::Const.Music.RatTracks <- ["music/rat.ogg"]

::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/marauding_rat_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/rat_chieftain_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/rat_warlord_action");

::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/contracts/drive_away_rat_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/contracts/return_rat_item_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/contracts/hunting_wolfrat_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/contracts/hunting_ratorge_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/contracts/hunting_hellpit_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/contracts/rat_restore_location_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/contracts/defend_settlement_rat_action");
	
::Const.FactionTrait.Actions[this.Const.FactionTrait.OrientalCityState].push("scripts/factions/contracts/drive_away_rat_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.OrientalCityState].push("scripts/factions/contracts/return_rat_item_action");

::Const.SkavenFootprints <- [
	"world_footprints_skavens_n",
	"world_footprints_skavens_ne",
	"world_footprints_skavens_e",
	"world_footprints_skavens_se",
	"world_footprints_skavens_s",
	"world_footprints_skavens_sw",
	"world_footprints_skavens_w",
	"world_footprints_skavens_nw"
];