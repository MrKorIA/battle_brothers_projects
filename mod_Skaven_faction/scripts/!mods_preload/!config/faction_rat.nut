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

addEntityType("RatClanrat", "Клановая крыса скавенов", "клановых крыс скавенов", "rat_clanrat_orientation");
addEntityType("RatAssassin", "Ночной бегун скавенов", "ночных бегунов скавенов", "rat_assassin_orientation");
addEntityType("RatWarrior", "Штурмовая крыса скавенов", "штурмовых крыс скавенов", "rat_warrior_orientation");
addEntityType("RatMonk", "Чумной монах скавенов", "чумных монахов скавенов", "rat_monk_orientation");
addEntityType("RatPackmaster", "Хозяин стаи скавенов", "хозяинов стаи скавенов", "rat_packmaster_orientation");
addEntityType("RatWarlord", "Вождь скавенов", "вождей скавенов", "rat_greyseer_orientation");
addEntityType("RatGreyseer", "Серый Провидец скавенов", "Серых Провидцев скавенов", "rat_greyseer_orientation");
addEntityType("HellPit", "Мерзость Адской Ямы", "Мерзостей Адской Ямы", "hellpit_orientation");
addEntityType("WolfRat", "Волкокрыс", "волкокрыс", "wolfrat_orientation");
addEntityType("RatOrge", "Крысоогр", "крысоогров", "ratorge_orientation");
addEntityType("RatOrgeArmored", "Бронированный крысоогр", "бронированных крысоогров", "ratorge_armored_orientation");
addEntityType("RatSwarm", "Крысиная стая", "крысиных стай", "ratswarm_orientation");
addEntityType("PlayerRatSwarm", "Крысиная стая", "крысиных стай", "ratswarm_orientation");
addEntityType("RatBannerMen", "Знаменосец скавенов", "знаменосцев скавенов", "rat_warlord_orientation");
addEntityType("RatGod01", "Повелитель тварей варп-провидец", "повелителей тварей варп-провидцев", "rat_god01_orientation");
addEntityType("RatGod02", "Повелитель тварей развратитель", "повелителей тварей развратителей", "rat_god02_orientation");
addEntityType("RatGod03", "Повелитель тварей обманщик", "повелителей тварей обманщиков", "rat_god03_orientation");
addEntityType("RatQueek", "Квик Головоруб", "Квик Головоруб", "rat_queek_orientation");
addEntityType("RatTretch", "Треч Трусливый Хвост", "Треч Трусливый Хвост", "rat_tretch_orientation");


::Const.World.FootprintsType.Skavens <- ::Const.World.FootprintsType.COUNT;
::Const.World.FootprintsType.COUNT = ::Const.World.FootprintsType.COUNT + 1;
::Const.Strings.FootprintsType.push("скавенами");

::Const.Strings.RatWarlordNames <- [
	"Лорд Скролк",
	"Икит Коготь",
	"Мастер Смерти Снитч",
	"Сквил Грызозуб",
	"Фескит",
	"Трот Нечистый",
	"Гнавдвелл",
	"Крач Коготь Рока",
	"Рикрук Режущий Клинок",
	"Скаррик Хребторез",
	"Скрит Червь-Крыса",
	"Скразслик"
];

::Const.Strings.RatGreyseerNames <- [
	"Пакритт",
	"Грибикк Рогатый",
	"Сквиктат",
	"Боха",
	"Тисквик",
	"Скриакуал",
	"Траткви",
	"Скабритт",
	"Криквик",
	"Ведьма Павших",
	"Кранскритт",
	"Джилкин Искривлённый",
	"Тисквик",
	"Критислик",
	"Танквонь",
	"Сликит",
	"Вулскрик",
	"Таумкриттл",
	"Лурквоал",
	"Раззел",
	"Скрилин Турнтик",
	"Скриттар",
	"Тратсник",
	"Гримон",
	"Раскнитт",
	"Квиквол",
	"Азорак Стальной Глаз",
	"Скретт",
	"Гнавдум",
	"Арквик",
	"Квик",
	"Скритчпасть"
];

::Const.Tactical.Actor.RatClanrat <- {
	XP = 150,
	ActionPoints = 9,
	Hitpoints = 45,
	Bravery = 35,
	Stamina = 90,
	MeleeSkill = 35,
	RangedSkill = 35,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.RatAssassin <- {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 55,
	Bravery = 70,
	Stamina = 125,
	MeleeSkill = 80,
	RangedSkill = 55,
	MeleeDefense = 10,
	RangedDefense = 20,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.RatWarrior <- {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 55,
	Stamina = 125,
	MeleeSkill = 60,
	RangedSkill = 55,
	MeleeDefense = 10,
	RangedDefense = 5,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.RatMonk <- {
	XP = 175,
	ActionPoints = 9,
	Hitpoints = 60,
	Bravery = 65,
	Stamina = 120,
	MeleeSkill = 50,
	RangedSkill = 50,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.RatPackmaster <- {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 80,
	Stamina = 150,
	MeleeSkill = 65,
	RangedSkill = 40,
	MeleeDefense = 15,
	RangedDefense = 5,
	Initiative = 90,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.RatWarlord <- {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 110,
	Bravery = 70,
	Stamina = 130,
	MeleeSkill = 75,
	RangedSkill = 65,
	MeleeDefense = 15,
	RangedDefense = 10,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.RatGreyseer <- {
	XP = 375,
	ActionPoints = 9,
	Hitpoints = 100,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 65,
	RangedSkill = 65,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.HellPit <- {
	XP = 800,
	ActionPoints = 7,
	Hitpoints = 1600,
	Bravery = 170,
	Stamina = 400,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = -15,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 30
};

::Const.Tactical.Actor.WolfRat <- {
	XP = 200,
	ActionPoints = 12,
	Hitpoints = 160,
	Bravery = 50,
	Stamina = 180,
	MeleeSkill = 50,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 160,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	FatigueRecoveryRate = 20,
	Armor = [
		0,
		0
	],
};

::Const.Tactical.Actor.RatOrge <- {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 750,
	Bravery = 90,
	Stamina = 400,
	MeleeSkill = 50,
	RangedSkill = 0,
	MeleeDefense = 0,
	RangedDefense = -5,
	Initiative = 105,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	]
	FatigueRecoveryRate = 30,
};

::Const.Tactical.Actor.RatOrgeArmored <- {
	XP = 450,
	ActionPoints = 9,
	Hitpoints = 750,
	Bravery = 105,
	Stamina = 400,
	MeleeSkill = 55,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = -5,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 30
};

::Const.Tactical.Actor.RatSwarm <- {
	XP = 50,
	ActionPoints = 12,
	Hitpoints = 45,
	Bravery = 30,
	Stamina = 130,
	MeleeSkill = 35,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 140,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.PlayerRatSwarm <- {
	XP = 70,
	ActionPoints = 12,
	Hitpoints = 65,
	Bravery = 40,
	Stamina = 130,
	MeleeSkill = 45,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.RatBannerMen <- {
	XP = 100,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 110,
	Stamina = 130,
	MeleeSkill = 40,
	RangedSkill = 40,
	MeleeDefense = 10,
	RangedDefense = 15,
	Initiative = 105,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.RatGod01 <- {
	XP = 1500,
	ActionPoints = 9,
	Hitpoints = 1800,
	Bravery = 999,
	Stamina = 400,
	MeleeSkill = 95,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 15,
	Initiative = 95,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		100,
		100
	],
	FatigueRecoveryRate = 30
};

::Const.Tactical.Actor.RatGod02 <- {
	XP = 1500,
	ActionPoints = 9,
	Hitpoints = 1800,
	Bravery = 999,
	Stamina = 400,
	MeleeSkill = 95,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 15,
	Initiative = 95,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		100,
		100
	],
	FatigueRecoveryRate = 30
};

::Const.Tactical.Actor.RatGod03 <- {
	XP = 1500,
	ActionPoints = 9,
	Hitpoints = 1800,
	Bravery = 999,
	Stamina = 400,
	MeleeSkill = 95,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 15,
	Initiative = 95,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		100,
		100
	],
	FatigueRecoveryRate = 30
};

::Const.Tactical.Actor.RatQueek <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 150,
	Bravery = 110,
	Stamina = 150,
	MeleeSkill = 80,
	RangedSkill = 65,
	MeleeDefense = 15,
	RangedDefense = 10,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 25
};

::Const.Tactical.Actor.RatTretch <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 250,
	Bravery = 110,
	Stamina = 150,
	MeleeSkill = 80,
	RangedSkill = 60,
	MeleeDefense = 15,
	RangedDefense = 10,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 25
};

::Const.World.Spawn.Troops.RatClanrat <-
	{
		ID = this.Const.EntityType.RatClanrat,
		Variant = 0,
		Strength = 8,
		Cost = 8,
		Row = 0,
		Script = "scripts/entity/tactical/enemies/rat_clanrat",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatAssassin <-
	{
		ID = this.Const.EntityType.RatAssassin,
		Variant = 0,
		Strength = 20,
		Cost = 20,
		Row = 1,
		Script = "scripts/entity/tactical/enemies/rat_assassin",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatWarrior <-
	{
		ID = this.Const.EntityType.RatWarrior,
		Variant = 0,
		Strength = 20,
		Cost = 20,
		Row = 0,
		Script = "scripts/entity/tactical/enemies/rat_warrior",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatMonk <-
	{
		ID = this.Const.EntityType.RatMonk,
		Variant = 0,
		Strength = 12,
		Cost = 12,
		Row = 0,
		Script = "scripts/entity/tactical/enemies/rat_monk",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatPackmaster <-
	{
		ID = this.Const.EntityType.RatPackmaster,
		Variant = 0,
		Strength = 30,
		Cost = 20,
		Row = 2,
		Script = "scripts/entity/tactical/enemies/rat_packmaster",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatWarlord <-
	{
		ID = this.Const.EntityType.RatWarlord,
		Variant = 10,
		Strength = 25,
		Cost = 25,
		Row = 2,
		Script = "scripts/entity/tactical/enemies/rat_warlord",
		NameList = this.Const.Strings.RatWarlordNames,
		TitleList = null
	}

::Const.World.Spawn.Troops.RatGreyseer <-
	{
		ID = this.Const.EntityType.RatGreyseer,
		Variant = 10,
		Strength = 30,
		Cost = 30,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/rat_greyseer",
		NameList = this.Const.Strings.RatGreyseerNames,
		TitleList = null
	}

::Const.World.Spawn.Troops.HellPit <-
	{
		ID = this.Const.EntityType.HellPit,
		Variant = 0,
		Strength = 50,
		Cost = 50,
		Row = -1,
		Script = "scripts/entity/tactical/enemies/hellpit",
		TitleList = null
	}

::Const.World.Spawn.Troops.WolfRat <-
	{
		ID = this.Const.EntityType.WolfRat,
		Variant = 0,
		Strength = 15,
		Cost = 20,
		Row = -1,
		Script = "scripts/entity/tactical/enemies/wolfrat",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatOrge <-
	{
		ID = this.Const.EntityType.RatOrge,
		Variant = 0,
		Strength = 45,
		Cost = 45,
		Row = 0,
		Script = "scripts/entity/tactical/enemies/ratorge",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatOrgeArmored <-
	{
		ID = this.Const.EntityType.RatOrgeArmored,
		Variant = 0,
		Strength = 55,
		Cost = 55,
		Row = 0,
		Script = "scripts/entity/tactical/enemies/ratorge_armored",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatSwarm <-
	{
		ID = this.Const.EntityType.RatSwarm,
		Variant = 0,
		Strength = 7,
		Cost = 7,
		Row = -1,
		Script = "scripts/entity/tactical/enemies/ratswarm",
		TitleList = null
	}

::Const.World.Spawn.Troops.PlayerRatSwarm <-
	{
		ID = this.Const.EntityType.PlayerRatSwarm,
		Variant = 0,
		Strength = 7,
		Cost = 7,
		Row = -1,
		Script = "scripts/entity/tactical/enemies/player_ratswarm",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatBannerMen <-
	{
		ID = this.Const.EntityType.RatBannerMen,
		Variant = 0,
		Strength = 15,
		Cost = 15,
		Row = 2,
		Script = "scripts/entity/tactical/enemies/rat_banner_men",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatGod01 <-
	{
		ID = this.Const.EntityType.RatGod01,
		Variant = 0,
		Strength = 0,
		Cost = 0,
		Row = 1,
		Script = "scripts/entity/tactical/enemies/rat_god_01",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatGod02 <-
	{
		ID = this.Const.EntityType.RatGod02,
		Variant = 0,
		Strength = 0,
		Cost = 0,
		Row = 1,
		Script = "scripts/entity/tactical/enemies/rat_god_02",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatGod03 <-
	{
		ID = this.Const.EntityType.RatGod03,
		Variant = 0,
		Strength = 0,
		Cost = 0,
		Row = 1,
		Script = "scripts/entity/tactical/enemies/rat_god_03",
		TitleList = null
	}

::Const.World.Spawn.Troops.RatQueek <-
	{
		ID = this.Const.EntityType.RatQueek,
		Variant = 15,
		Strength = 25,
		Cost = 45,
		Row = 1,
		Script = "scripts/entity/tactical/enemies/rat_queek",
		NameList = [
            "Квик Головоруб"
        ],
		TitleList = [
			"Повелитель Города Столпов"
		]
	}

::Const.World.Spawn.Troops.RatTretch <-
	{
		ID = this.Const.EntityType.RatTretch,
		Variant = 0,
		Strength = 25,
		Cost = 45,
		Row = 1,
		Script = "scripts/entity/tactical/enemies/rat_tretch",
		NameList = [
            "Треч Трусливый Хвост"
        ],
		TitleList = [
			"Великий Вождь Глубинных Нор"
		]
	}
