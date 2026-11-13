// Юнит-босс «Генерал Великой Орды» + регистрация кризисных actions Jurchen.
// ВАЖНО: файл включается из load.nut внутри queue(">mod_msu", ">mod_jin", ">mod_mgl", ...) —
// Const.World.Spawn.Troops.* обеих фракций гарантированно уже загружены.

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

addEntityType("HordeGeneral", "Генерал Великой Орды", "генералы Великой Орды", "horde_general_orientation");

::Const.Tactical.Actor.HordeGeneral <- {
	XP = 750,
	ActionPoints = 9,
	Hitpoints = 200,
	Bravery = 130,
	Stamina = 180,
	MeleeSkill = 90,
	RangedSkill = 60,
	MeleeDefense = 25,
	RangedDefense = 25,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 25
};

// Имена и титулы Генерала — полководцы средневековой китайско-чурчжэньской
// армии клана Ваньянь (основатели империи Цзинь): исторические якоря
// (Агуда, Уцимай) + правдоподобные имена того же звучания.
::Const.Strings.HordeGeneralNames <- ["Ваньянь Агуда", "Ваньянь Уцимай", "Ваньянь Уяшу", "Ваньянь Хэла", "Ваньянь Мэнъэ", "Ваньянь Лушкуй", "Ваньянь Сянлянь", "Моувэнь Тяньшэн", "Уцимай Малань", "Хэлэбу Сюйянь"];
::Const.Strings.HordeGeneralTitles <- ["Победоносный", "Непобеждённый", "Меч Великого Хана", "Опора Орды", "Гроза Западных Марок", "Сокол хана", "Железный полководец", "Владыка степей", "Гром десяти тысяч", "Хранитель Чёрного Пороха"];

::Const.World.Spawn.Troops.HordeGeneral <-
{
	ID = this.Const.EntityType.HordeGeneral,
	Variant = 5,
	Strength = 40,
	Cost = 80,
	Row = 1,
	Script = "scripts/entity/tactical/humans/horde_general",
	NameList = this.Const.Strings.HordeGeneralNames,
	TitleList = this.Const.Strings.HordeGeneralTitles
};

addEntityType("HordeCatapult", "Онагр орды", "онагры орды", "horde_catapult_orientation");

::Const.World.Spawn.Troops.HordeCatapult <-
{
	ID = this.Const.EntityType.HordeCatapult,
	Variant = 0,
	Strength = 50,
	Cost = 25,
	Row = 2,
	Script = "scripts/entity/tactical/objective/horde_catapult"
};

// Кризисные actions вешаем на трейт Jurchen (Mgl в кризисе союзна — силы набирает Jurchen).
// Deck фракций строится из этого списка при генерации мира; для сейвов, созданных
// без мода, actions не подхватятся (vanilla-совместимое ограничение).
::Const.FactionTrait.Actions[this.Const.FactionTrait.Jurchen].push("scripts/factions/actions/build_horde_camp_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Jurchen].push("scripts/factions/actions/send_horde_roamers_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Jurchen].push("scripts/factions/actions/send_horde_raiders_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.Jurchen].push("scripts/factions/actions/send_horde_army_action");

// Кризисные контракты — на трейт NobleHouse (как ванильные кризисные контракты).
// Только новые кампании (Deck строится при генерации мира).
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/horde_root_out_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/horde_last_stand_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/horde_break_siege_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/horde_free_prisoners_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/horde_decisive_battle_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/contracts/horde_powder_action");

// Южный вариант «Искоренить орду» — на трейт городов-государств (TZ: южане нанимают
// наёмников, чтобы не светиться самим; логика контракта идентична северному).
::Const.FactionTrait.Actions[this.Const.FactionTrait.OrientalCityState].push("scripts/factions/contracts/horde_root_out_southern_action");
