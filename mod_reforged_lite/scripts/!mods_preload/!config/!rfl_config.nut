local gt = this.getroottable();

local function addEntityType( _id, _name, _namePlural, _icon )
{
	if (!("EntityTypeMax" in ::Const))
	{
		local max = 0;
		foreach (key, value in ::Const.EntityType)
		{
			if (typeof value == "integer" && value > max) max = value;
		}
		::Const.EntityTypeMax <- max;
	}
	::Const.EntityType[_id] <- ++::Const.EntityTypeMax;
	::Const.Strings.EntityName.push(_name);
	::Const.Strings.EntityNamePlural.push(_namePlural);
	::Const.EntityIcon.push(_icon);
}

//draugrs
addEntityType("RF_DraugrThrall", "Курганник раб", "курганников рабов", "rf_draugr_thrall_orientation");
addEntityType("RF_DraugrThrallBodyguard", "Курганник раб", "курганников рабов", "rf_draugr_thrall_orientation");
addEntityType("RF_DraugrWarrior", "Курганник дренгр", "курганников дренгров", "rf_draugr_warrior_orientation");
addEntityType("RF_DraugrWarriorBodyguard", "Курганник дренгр", "курганников дренгров", "rf_draugr_warrior_orientation");
addEntityType("RF_DraugrHuskarl", "Курганник хускарл", "курганников хускарлов", "rf_draugr_huskarl_orientation");
addEntityType("RF_DraugrHuskarlBodyguard", "Курганник хускарл", "курганников хускарлов", "rf_draugr_huskarl_orientation");
addEntityType("RF_DraugrHero", "Курганник герой", "курганников героев", "rf_draugr_hero_orientation");
addEntityType("RF_DraugrHeroChampion", "Курганник герой", "курганников героев", "rf_draugr_hero_orientation");
addEntityType("RF_DraugrShaman", "Курганник провидец", "курганников провидцев", "rf_draugr_shaman_orientation");

local highest = 0;
foreach (v in ::Const.FactionTrait)
{
	if (typeof v == "integer" && v > highest)
	{
		highest = v;
	}
}

local function addFaction( _key, _color, _base, _actions, _alliance, _battleTracks )
{
	::Const.FactionType[_key] <- ::Const.FactionType.COUNT;
	::Const.FactionType.COUNT++;

	::Const.Faction[_key] <- ::Const.Faction.COUNT;
	::Const.Faction.COUNT++;

	::Const.FactionColor.push(_color);

	::Const.FactionBase.push(_base);

	::Const.FactionAlliance.push(_alliance);

	::Const.FactionTrait[_key] <- ++highest;
	::Const.FactionTrait.Actions.push(_actions);

	::Const.Music.BattleTracks.push(_battleTracks);
}

addFaction(
	"RF_Draugr",
	::createColor("#bd00c4"),
	"bust_base_rf_draugr_01",
	[
		"scripts/factions/actions/rf_build_draugr_camp_action"
	],
	[
		// No alliances
	],
	[
		"music/rf_draugr_1.ogg",
		"music/rf_draugr_2.ogg"
	]
);
