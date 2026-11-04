
local gt = this.getroottable();
::Const.CultistConfig <- {
	MaxLairsInDevelopment = 3,
	SacrificeForLvl2 = 15, 				// How many sacrifices must be delivered before upgrade to lvl2
	SacrificeForLvl3 = 30,				// ""  lvl3
	MaxSacrifices = 30,					// Hax scaling of a camp
	LairResourcesPerSacrifice = 10,		// How many resources a camp gains per sacrifice
	MaxLairResources = 300,				// Effectively the same as maxSacrifices
	MinLairResources = 100,				// Can't go below this, even with fewer sacrifices
	LairNames =[						// Depending on lvl
	["Укрытие культистов"],
	["Логово культистов"],
	["Убежище культистов"],
	],
	MaxRitualSites = 2, 				// Max ritual sites on the map at a time
	DelayBetweenRaids = 4, 				// Days before another raid can be sent out, increased by size
	EnlightenedFanaticMaxDay = 200.0, 	// Day at which fanatic scaling reaches max
	EnlightenedFanaticMaxOdds = 40, 	// Max odds that fanatic is enlightened based on day scaling
	EnlightenedFanaticMinOdds = 10,		// Min odds that fanatic is enlightened
}




::Const.FactionType.Cultists <- ::Const.FactionType.COUNT;
::Const.FactionType.COUNT++
::Const.Faction.Cultists <- ::Const.Faction.COUNT;
::Const.Faction.COUNT++
::Const.FactionBase.push("bust_base_mod_cultist")
::Const.Music.CultistTracks <- ["music/bensound-instinct.ogg", "music/band_of_drums.ogg"]
::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/actions/drive_away_cultists_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.NobleHouse].push("scripts/factions/actions/free_cultist_prisoner_action");

::Const.CultistTraits <- 
[
	"scripts/factions/actions/spawn_cultist_roamers_action", 
	"scripts/factions/actions/spawn_cultist_camp_action", 
	"scripts/factions/actions/spawn_cultist_legendary_camp_action", 
	"scripts/factions/actions/spawn_cultist_ritual_site_action",
	"scripts/factions/actions/spawn_cultist_raiders_action"
]


::Const.Items.NamedCultistWeapons <- 
[
	"weapons/named/cultist_named_billhook", 
	"weapons/named/cultist_named_crowbeak", 
	"weapons/named/cultist_named_scythe"
];

//Move these to MSU
local function addAIBehaviour(_id, _name, _order, _score = null)
{

	::Const.AI.Behavior.ID[_id] <- ::Const.AI.Behavior.ID.COUNT
	::Const.AI.Behavior.ID.COUNT++
	::Const.AI.Behavior.Name.push(_name)
	::Const.AI.Behavior.Order[_id] <- _order;
	if(_score != null)
	{
		::Const.AI.Behavior.Score[_id] <- _score;
	}
	
}
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
local function addItemType(_id)
{
	if (_id in ::Const.Items.ItemType)
	{
		return;
	}
	local highest = -1;
	foreach (key , value in ::Const.Items.ItemType)
	{
		if (value > highest) highest = value; 
	}
	::Const.Items.ItemType[_id] <- highest * 2;
	::Const.Items.ItemFilter.All = ::Const.Items.ItemFilter.All | ::Const.Items.ItemType[_id];
}

addItemType("Cultist");

addAIBehaviour("ModDavkulPriestSupport", "ModDavkul.Priest Move into Support Range", 51, 100)
addAIBehaviour("ModDavkulPriestDarkChant", "ModDavkul.Priest Dark Chant", 50, 150)
addAIBehaviour("ModDavkulPriestSacrifice", "ModDavkul.Priest Sacrifice Ally", 100)
addAIBehaviour("ModDavkulHighPriestReinforcements", "ModDavkul.HighPriest Summon Reinforcements", 50, 100)
addAIBehaviour("ModDavkulSacrificeStick", "ModDavkul.Sacrifice Stick to Priest", 100)
addAIBehaviour("ModDavkulHeavySling", "ModDavkul.Hunter Heavy Sling", 21)
addAIBehaviour("ModDavkulMancatcherCatch", "ModDavkul.Mancatcher Catch", 21)
addAIBehaviour("ModDavkulMancatcherRattle", "ModDavkul.Mancatcher Rattle", 21)

addEntityType("Cultist_Sacrifice", "Жертва Давкула", "жертв Давкула", "cultist_orientation");
addEntityType("Cultist_Acolyte", "Послушник Давкула", "послушников Давкула", "acolyte_orientation");
addEntityType("Cultist_Fanatic", "Фанатик Давкула", "фанатиков Давкула", "fanatic_orientation");
addEntityType("Cultist_Fanatic_Enlightened", "Просвещённый фанатик Давкула", "просвещённых фанатиков Давкула", "fanatic_orientation");
addEntityType("Cultist_Hunter", "Охотник Давкула", "охотников Давкула", "hunter_orientation");
addEntityType("Cultist_Defiler", "Осквернитель Давкула", "осквернителей Давкула", "defiler_orientation");
addEntityType("Cultist_Mancatcher", "Ловец Давкула", "ловцов Давкула", "mancatcher_orientation");
addEntityType("Cultist_Preacher", "Провозвестник Давкула", "провозвестников Давкула", "prophet_orientation");
addEntityType("Cultist_Herald", "Глашатай Давкула", "глашатаев Давкула", "prophet_orientation");
addEntityType("Cultist_Prophet", "Пророк Давкула", "пророков Давкула", "prophet_orientation");
addEntityType("Cultist_High_Priest", "Верховный жрец", "верховных жрецов", "prophet_orientation");

::Const.Items.NamedCultistHelmets <- ["helmets/named/cultist_flesh_defiler_named"];

::Const.Strings.DefilerNames <- ["Горат", "Хаагрот", "Скарр", "Воргарот", "Драккар", "К'рул", "Харгнир", "Моргфар", "Мунгуин", "Шакар", "Хоглот", "Флоглин", "Пумир", "Рел'сот"]
::Const.Strings.DefilerTitles <- ["Разрушитель", "Обугленный", "Нечистый", "Многословный", "Непобедимый", "Кровавый", "Кулак Давкула", "Непоколебимый", "Ужасный", "Пепельный", "Пламенный", "Безликий"]

::Const.World.Spawn.Troops.Cultist_Sacrifice <-
{
	ID = this.Const.EntityType.Cultist_Sacrifice,
	Variant = 0,
	Strength = 1,
	Cost = 1,
	Row = 2,
	Script = "scripts/entity/tactical/cultist/mod_cultist_sacrifice",
	TitleList = null
}

::Const.World.Spawn.Troops.Cultist_Acolyte <-
{
	ID = this.Const.EntityType.Cultist_Acolyte,
	Variant = 0,
	Strength = 10,
	Cost = 10,
	Row = 0,
	Script = "scripts/entity/tactical/cultist/mod_cultist_acolyte",
	TitleList = null
}
::Const.World.Spawn.Troops.Cultist_Fanatic <-
{
	ID = this.Const.EntityType.Cultist_Fanatic,
	Variant = 0,
	Strength = 20,
	Cost = 20,
	Row = 0,
	Script = "scripts/entity/tactical/cultist/mod_cultist_fanatic",
	TitleList = null
}
::Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened <-
{
	ID = this.Const.EntityType.Cultist_Fanatic_Enlightened,
	Variant = 0,
	Strength = 25,
	Cost = 25,
	Row = 0,
	Script = "scripts/entity/tactical/cultist/mod_cultist_fanatic_enlightened",
	TitleList = null
}
::Const.World.Spawn.Troops.Cultist_Hunter <-
{
	ID = this.Const.EntityType.Cultist_Hunter,
	Variant = 0,
	Strength = 20,
	Cost = 25,
	Row = 2,
	Script = "scripts/entity/tactical/cultist/mod_cultist_hunter",
	TitleList = null
}

::Const.World.Spawn.Troops.Cultist_Defiler <-
{
	ID = this.Const.EntityType.Cultist_Defiler,
	Variant = 3,
	Strength = 40,
	Cost = 40,
	Row = 1,
	Script = "scripts/entity/tactical/cultist/mod_cultist_defiler",
	NameList = this.Const.Strings.DefilerNames,
	TitleList = this.Const.Strings.DefilerTitles
}

::Const.World.Spawn.Troops.Cultist_Mancatcher <-
{
	ID = this.Const.EntityType.Cultist_Mancatcher,
	Variant = 0,
	Strength = 20,
	Cost = 25,
	Row = 1,
	Script = "scripts/entity/tactical/cultist/mod_cultist_mancatcher",
	TitleList = null
}
::Const.World.Spawn.Troops.Cultist_Preacher <-
{
	ID = this.Const.EntityType.Cultist_Preacher,
	Variant = 0,
	Strength = 30,
	Cost = 30,
	Row = 2,
	Script = "scripts/entity/tactical/cultist/mod_cultist_preacher",
	TitleList = null
}
::Const.World.Spawn.Troops.Cultist_Herald <-
{
	ID = this.Const.EntityType.Cultist_Herald,
	Variant = 0,
	Strength = 30,
	Cost = 30,
	Row = 2,
	Script = "scripts/entity/tactical/cultist/mod_cultist_herald",
	TitleList = null
}
::Const.World.Spawn.Troops.Cultist_Prophet <-
{
	ID = this.Const.EntityType.Cultist_Prophet,
	Variant = 0,
	Strength = 30,
	Cost = 30,
	Row = 2,
	Script = "scripts/entity/tactical/cultist/mod_cultist_prophet",
	TitleList = null
}
::Const.World.Spawn.Troops.Cultist_High_Priest <-
{
	ID = this.Const.EntityType.Cultist_High_Priest,
	Variant = 0,
	Strength = 50,
	Cost = 50,
	Row = 3,
	Script = "scripts/entity/tactical/cultist/mod_cultist_high_priest",
	TitleList = null
}
::Const.Tactical.Actor.Cultist_Sacrifice <- {
	XP = 100,
	ActionPoints = 12,
	Hitpoints = 50,
	Bravery = 45,
	Stamina = 100,
	MeleeSkill = 0,
	RangedSkill = 0,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.Cultist_Acolyte <- {
	XP = 150,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 55,
	Stamina = 100,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 95,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};
::Const.Tactical.Actor.Cultist_Fanatic <- {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 65,
	Stamina = 100,
	MeleeSkill = 65,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};
::Const.Tactical.Actor.Cultist_Hunter <- {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 65,
	Stamina = 100,
	MeleeSkill = 40,
	RangedSkill = 70,
	MeleeDefense = 0,
	RangedDefense = 10,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};
::Const.Tactical.Actor.Cultist_Defiler <- {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 85,
	RangedSkill = 0,
	MeleeDefense = 18,
	RangedDefense = 0,
	Initiative = 90,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};
::Const.Tactical.Actor.Cultist_Mancatcher <- {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 55,
	Bravery = 60,
	Stamina = 130,
	MeleeSkill = 70,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 5,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};
::Const.Tactical.Actor.Cultist_Preacher <- {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 80,
	Stamina = 100,
	MeleeSkill = 60,
	RangedSkill = 15,
	MeleeDefense = 15,
	RangedDefense = 15,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 25
};
::Const.Tactical.Actor.Cultist_Herald <- {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 70,
	RangedSkill = 20,
	MeleeDefense = 20,
	RangedDefense = 20,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 25
};
::Const.Tactical.Actor.Cultist_Prophet <- {
	XP = 300,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 120,
	Stamina = 100,
	MeleeSkill = 80,
	RangedSkill = 25,
	MeleeDefense = 25,
	RangedDefense = 25,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 25
};
::Const.Tactical.Actor.Cultist_High_Priest <- {
	XP = 600,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 120,
	Stamina = 450,
	MeleeSkill = 90,
	RangedSkill = 40,
	MeleeDefense = 40,
	RangedDefense = 40,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 25
};
