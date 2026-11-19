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
	"Mgl",
	::createColor("#ff9595"),
	"bust_base_mgl",
	[
		"scripts/factions/actions/build_mgl_camp_action",
		"scripts/factions/actions/send_mgl_ambushers_action",
		"scripts/factions/actions/send_mgl_roamers_action",
		"scripts/factions/actions/defend_mgl_action"
	],
	[
		// No alliances
	],
	[
		"music/mgl.ogg"
	]
);

::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/actions/drive_away_mgl_action");

::Const.MglBanners <- [
	"banner_mgl"
];

::Const.World.LocationNames.IronHordeCamp <- [
	"Курган белых костей",
	"Ставка степного волка",
	"Аул кровавого копыта",
	"Юрты серого ветра",
	"Стоянка сломанных стрел",
	"Лагерь орлиного пера",
	"Урочище диких табунов",
	"Кочевье железного хлыста",
	"Стойбище кривых сабель",
	"Овраг сухих черепов",
	"Ставка одноглазого бека",
	"Юрты волчьей пасти",
	"Лагерь степных коршунов",
	"Стан красного аркана",
	"Стойбище дымных костров",
	"Курган вороньего крика",
	"Ставка гнутых луков",
	"Юрты ночной охоты",
	"Кочевье пепельных степей",
	"Лагерь железных стремян",
	"Ставка старого батыра"
];