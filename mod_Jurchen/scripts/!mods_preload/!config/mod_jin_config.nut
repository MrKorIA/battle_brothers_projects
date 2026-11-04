::Const.Strings.jinweapon15Names <- [
	"Змеиное копьё \'Шэмао\'",
	"Пронзающий"
];
::Const.Strings.jinweapon18Names <- [
	"Несравненный в мире",
	"Фан Тянь Хуа Цзи"
];
::Const.Strings.jinweapon20Names <- [
	"Разрушитель",
];
::Const.Strings.jinweapon02Names <- [
	"Шип"
];
::Const.Strings.jinweapon03Names <- [
	"Длинный полумесяц"
];
::Const.Strings.jinweapon04Names <- [
	"Сокрушитель гор"
];
::Const.Strings.jinweapon05Names <- [
	"Палица \'Кровопийца\'"
];
::Const.Strings.jinweapon13Names <- [
	"Палица \'Завоеватель\'"
];
::Const.Strings.jinNames <- [
	"Ваньянь",
	"Дэцзи"
];

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
	"Jurchen",
	::createColor("#b75a00"),
	"bust_base_jin",
	[
        "scripts/factions/actions/build_jin_camp_action",
        "scripts/factions/actions/send_jin_ambushers_action",
        "scripts/factions/actions/send_jin_roamers_action",
        "scripts/factions/actions/defend_jin_action"
	],
	[
		// No alliances
	],
	[
		"music/jin.ogg"
	]
);

::Const.Tactical.Actor.NomadFireBlunderbuss <- {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 80,
	Stamina = 120,
	MeleeSkill = 65,
	RangedSkill = 75,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.NomadHalberdMaster <- {
	XP = 550,
	ActionPoints = 9,
	Hitpoints = 200,
	Bravery = 130,
	Stamina = 185,
	MeleeSkill = 70,
	RangedSkill = 55,
	MeleeDefense = 15,
	RangedDefense = 5,
	Initiative = 150,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.NomadInfantry <- {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 70,
	Stamina = 120,
	MeleeSkill = 60,
	RangedSkill = 5,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.NomadIronPagoda <- {
	XP = 450,
	ActionPoints = 9,
	Hitpoints = 130,
	Bravery = 100,
	Stamina = 165,
	MeleeSkill = 80,
	RangedSkill = 55,
	MeleeDefense = 15,
	RangedDefense = 10,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.NomadSpearMaster <- {
	XP = 550,
	ActionPoints = 9,
	Hitpoints = 130,
	Bravery = 100,
	Stamina = 145,
	MeleeSkill = 90,
	RangedSkill = 55,
	MeleeDefense = 40,
	RangedDefense = 40,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.NomadCenturion <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 150,
	Bravery = 110,
	Stamina = 165,
	MeleeSkill = 85,
	RangedSkill = 55,
	MeleeDefense = 20,
	RangedDefense = 20,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

local function addEntityType(_id, _name, _namePlural, _icon)
{
	if (!("EntityTypeMax" in ::Const))
	{
		local max = 0;
		foreach(key, value in ::Const.EntityType)
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

addEntityType("NomadFireBlunderbuss", "Хоцян-огнемётчик", "хоцян-огнемётчиков", "nomad_14_orientation");
addEntityType("NomadHalberdMaster", "Мастер цзи", "мастеров цзи", "nomad_11_orientation");
addEntityType("NomadInfantry", "Цзядин", "Цзядинов", "nomad_09_orientation");
addEntityType("NomadIronPagoda", "Тефуту", "тефуту", "nomad_12_orientation");
addEntityType("NomadSpearMaster", "Копейщик Цян", "копейщиков цян", "nomad_10_orientation");
addEntityType("NomadCenturion", "Мэнъань", "мэнъань", "nomad_13_orientation");

::Const.World.Spawn.Troops.NomadFireBlunderbuss <-
{
    ID = this.Const.EntityType.NomadFireBlunderbuss,
    Variant = 0,
    Strength = 10,
    Cost = 20,
    Row = 3,
    Script = "scripts/entity/tactical/humans/nomad_fireblunderbuss",
    TitleList = null
}

::Const.Strings.NomadHalberdMasterNames <- ["Акдун", "Гао", "Амбалингу", "Пэй" , "Колхороконггэ", "Фиянтахун", "Габсихиян", "Гияхун", "Юрганга", "Тонго Джильжан", "Ебкен Хайха" ]
::Const.Strings.NomadHalberdMasterTitles <- ["Десять тысяч против одного", "Могучий", "Лев", "Ужасающий", "Легендарный генерал", "Пограничный офицер", "Шрам"]
	
::Const.World.Spawn.Troops.NomadHalberdMaster <-
{
    ID = this.Const.EntityType.NomadHalberdMaster,
    Variant = 5,
    Strength = 30,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/nomad_halberdmaster",
    NameList = this.Const.Strings.NomadHalberdMasterNames,
    TitleList = this.Const.Strings.NomadHalberdMasterTitles
}
	
::Const.World.Spawn.Troops.NomadInfantry <-
{
    ID = this.Const.EntityType.NomadInfantry,
    Variant = 0,
    Strength = 10,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/nomad_infantry",
    TitleList = null
}
	
::Const.World.Spawn.Troops.NomadIronPagoda <-
{
    ID = this.Const.EntityType.NomadIronPagoda,
    Variant = 0,
    Strength = 20,
    Cost = 30,
    Row = 1,
    Script = "scripts/entity/tactical/humans/nomad_ironpagoda",
    TitleList = null
}

::Const.Strings.NomadSpearMasterNames <- ["Дэцзи", "Ботэбу", "Дэчжибумби", "Исибу" , "Вэлимби", "Исибумби", "Алибу", "Хурубу" ]
::Const.Strings.NomadSpearMasterTitles <- ["Легендарный", "Стремительный", "Хитроумный", "Быстрый орёл", "Лучший из мастеров копья", "Искусный в боевых искусствах", "Точный удар"]
	
::Const.World.Spawn.Troops.NomadSpearMaster <-
{
    ID = this.Const.EntityType.NomadSpearMaster,
    Variant = 5,
    Strength = 20,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/nomad_spearmaster",
    NameList = this.Const.Strings.NomadSpearMasterNames,
    TitleList = this.Const.Strings.NomadSpearMasterTitles
}

::Const.Strings.NomadCenturionNames <- ["Вангия", "Абкай хоргику", "Бодохонгго", "Фассанга" , "Фуджурунга", "Гэлмэрджэмби", "Гильджан", "Кэсинггэ" , "Мудури Морин", "Мукдэмби", "Ниоварги Гаша"  ]
::Const.Strings.NomadCenturionTitles <- ["Опора небес", "Находчивый", "Превосходный", "Выдающаяся личность", "Безупречный", "Благословенный муж", "Кандидат в командиры"]
	
::Const.World.Spawn.Troops.NomadCenturion <-
{
    ID = this.Const.EntityType.NomadCenturion,
    Variant = 5,
    Strength = 20,
    Cost = 30,
    Row = 1,
    Script = "scripts/entity/tactical/humans/nomad_centurion",
    NameList = this.Const.Strings.NomadCenturionNames,
    TitleList = this.Const.Strings.NomadCenturionTitles
}
	
::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/actions/drive_away_jin_action");	
::Const.FactionTrait.Actions[this.Const.FactionTrait.OrientalCityState].push("scripts/factions/actions/drive_away_jin_action");	