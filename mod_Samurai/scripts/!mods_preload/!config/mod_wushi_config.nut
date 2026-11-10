local function addProjectileType( _key, _decals, _sprite )
{
    local targetSize = ::Const.ProjectileType.COUNT;

    while (::Const.ProjectileDecals.len() < targetSize)
    {
        ::Const.ProjectileDecals.push([]);
    }

    while (::Const.ProjectileSprite.len() < targetSize)
    {
        ::Const.ProjectileSprite.push("");
    }

    ::Const.ProjectileType[_key] <- ::Const.ProjectileType.COUNT;
    ::Const.ProjectileType.COUNT += 1;
    ::Const.ProjectileDecals.push(_decals);
    ::Const.ProjectileSprite.push(_sprite);
}

addProjectileType("Shoulijian", ["shoulijian_missed_01"], "projectile_shoulijian");
addProjectileType("Shoulijian02", ["shoulijian02_missed_01"], "projectile_shoulijian02");
addProjectileType("Shoulijian03", ["shoulijian03_missed_01"], "projectile_shoulijian03");

local highest = 0;
foreach (v in ::Const.FactionTrait)
{
	if (typeof v == "integer" && v > highest)
	{
		highest = v;
	}
}

::Const.FactionTrait.Actions[this.Const.FactionTrait.Settlement].push("scripts/factions/actions/drive_away_wushi_action");
::Const.FactionTrait.Actions[this.Const.FactionTrait.OrientalCityState].push("scripts/factions/actions/drive_away_wushi_action");

local function addFaction( _key, _color, _base, _actions, _alliance, _battleTracks )
{
	::Const.FactionType[_key] <- ::Const.FactionType.COUNT;
	::Const.FactionType.COUNT++;

	::Const.Faction[_key] <- ::Const.Faction.COUNT;
	::Const.Faction.COUNT++;

	::Const.FactionColor.push(_color);

	::Const.FactionBase.push(_base);

	::Const.FactionAlliance.push(_alliance);

    foreach (ally in _alliance) {
        ::Const.FactionAlliance[ally].push(::Const.FactionType[_key]);
    }

	::Const.FactionTrait[_key] <- ++highest;
	::Const.FactionTrait.Actions.push(_actions);

	::Const.Music.BattleTracks.push(_battleTracks);
}

addFaction(
	"Wushi",
	::createColor("#b75a00"),
	"banner_wushi",
	[
		"scripts/factions/actions/build_wushi_camp_action",
		"scripts/factions/actions/send_wushi_ambushers_action",
		"scripts/factions/actions/send_wushi_roamers_action",
		"scripts/factions/actions/defend_wushi_action"
	],
	[
		// No alliances
	],
	[
		"music/wushi.ogg"
	]
);

addFaction(
	"Zhujiancun",
	::createColor("#b75a00"),
	"banner_wushi",
	[

	],
	[
		this.Const.Faction.None,
		this.Const.Faction.Player,
		this.Const.Faction.PlayerAnimals,
		this.Const.Faction.Enemy,
		this.Const.Faction.Civilian,
		this.Const.Faction.NobleHouse,
		this.Const.Faction.Bandits,
		this.Const.Faction.Beasts,
		this.Const.Faction.Undead,
		this.Const.Faction.Orcs,
		this.Const.Faction.Goblins
	],
	[
		"music/wushi.ogg"
	]
);

if (::mods_getRegisteredMod("mod_jin") != null && "Jurchen" in ::Const.Faction)
{
	::Const.FactionAlliance[::Const.Faction.Zhujiancun].push(::Const.Faction.Jurchen);
	::Const.FactionAlliance[::Const.Faction.Jurchen].push(::Const.Faction.Zhujiancun);
}

if (::mods_getRegisteredMod("mod_mgl") != null && "Mgl" in ::Const.Faction)
{
	::Const.FactionAlliance[::Const.Faction.Zhujiancun].push(::Const.Faction.Mgl);
	::Const.FactionAlliance[::Const.Faction.Mgl].push(::Const.Faction.Zhujiancun);
}

::Const.WushiBanners <- [
	"banner_wushi"	
];

::Const.Tactical.Actor.Renzhe <- {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 100,
	Bravery = 90,
	Stamina = 120,
	MeleeSkill = 80,
	RangedSkill = 5,
	MeleeDefense = 25,
	RangedDefense = 5,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.Renzhe02 <- {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 100,
	Bravery = 80,
	Stamina = 120,
	MeleeSkill = 65,
	RangedSkill = 65,
	MeleeDefense = 20,
	RangedDefense = 20,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.Sengbing <- {
	XP = 300,
	ActionPoints = 9,
	Hitpoints = 100,
	Bravery = 180,
	Stamina = 135,
	MeleeSkill = 65,
	RangedSkill = 5,
	MeleeDefense = 15,
	RangedDefense = 15,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.Wushi <- {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 130,
	Bravery = 100,
	Stamina = 130,
	MeleeSkill = 65,
	RangedSkill = 55,
	MeleeDefense = 20,
	RangedDefense = 20,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.Tactical.Actor.Wushi02 <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 190,
	Bravery = 180,
	Stamina = 145,
	MeleeSkill = 80,
	RangedSkill = 5,
	MeleeDefense = 30,
	RangedDefense = 15,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.Wushi03 <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 190,
	Bravery = 180,
	Stamina = 145,
	MeleeSkill = 85,
	RangedSkill = 5,
	MeleeDefense = 30,
	RangedDefense = 15,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.Wushi04 <- {
	XP = 800,
	ActionPoints = 9,
	Hitpoints = 200,
	Bravery = 180,
	Stamina = 155,
	MeleeSkill = 85,
	RangedSkill = 65,
	MeleeDefense = 35,
	RangedDefense = 15,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.Wushi05 <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 200,
	Bravery = 180,
	Stamina = 155,
	MeleeSkill = 80,
	RangedSkill = 5,
	MeleeDefense = 25,
	RangedDefense = 15,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Tactical.Actor.Zuqing <- {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 80,
	Stamina = 125,
	MeleeSkill = 55,
	RangedSkill = 5,
	MeleeDefense = 15,
	RangedDefense = 15,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.World.Spawn.Troops.Renzhe <-
{
    ID = this.Const.EntityType.Renzhe,
    Variant = 1,
    Strength = 10,
    Cost = 35,
    Row = 3,
    Script = "scripts/entity/tactical/humans/renzhe",
    NameList = this.Const.Strings.SamuraiLeaderNames,
    TitleList = null
};
	
::Const.World.Spawn.Troops.Renzhe02 <-
{
    ID = this.Const.EntityType.Renzhe02,
    Variant = 0,
    Strength = 10,
    Cost = 25,
    Row = 3,
    Script = "scripts/entity/tactical/humans/renzhe02",
    TitleList = null
};

::Const.World.Spawn.Troops.Sengbing <-
{
    ID = this.Const.EntityType.Sengbing,
    Variant = 1,
    Strength = 20,
    Cost = 20,
    Row = 1,
    Script = "scripts/entity/tactical/humans/sengbing",
    TitleList = null
};

::Const.World.Spawn.Troops.Wushi <-
{
    ID = this.Const.EntityType.Wushi,
    Variant = 0,
    Strength = 10,
    Cost = 35,
    Row = 3,
    Script = "scripts/entity/tactical/humans/wushi",
    TitleList = null
};

::Const.World.Spawn.Troops.Wushi02 <-
{
    ID = this.Const.EntityType.Wushi02,
    Variant = 200,
    Strength = 20,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/wushi02",
    TitleList = null
};

::Const.World.Spawn.Troops.Wushi03 <-
{
    ID = this.Const.EntityType.Wushi03,
    Variant = 200,
    Strength = 20,
    Cost = 45,
    Row = 1,
    Script = "scripts/entity/tactical/humans/wushi03",
    TitleList = null
};

::Const.World.Spawn.Troops.Wushi04 <-
{
    ID = this.Const.EntityType.Wushi04,
    Variant = 200,
    Strength = 20,
    Cost = 60,
    Row = 1,
    Script = "scripts/entity/tactical/humans/wushi04",
    TitleList = null
};

::Const.World.Spawn.Troops.Wushi05 <-
{
    ID = this.Const.EntityType.Wushi05,
    Variant = 200,
    Strength = 20,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/wushi05",
    TitleList = null
};

::Const.World.Spawn.Troops.Zuqing <-
{
    ID = this.Const.EntityType.Zuqing,
    Variant = 0,
    Strength = 20,
    Cost = 20,
    Row = 1,
    Script = "scripts/entity/tactical/humans/zuqing",
    TitleList = null
};


::Const.Tactical.AttackEffectZhanji02 <- [
	{
		Brush = ""
	},
	{
		Brush = "zhanji_03",
		Movement0 = this.createVec(120, 90),
		Movement1 = this.createVec(-120, -90),
		Offset = this.createVec(-100, -40)
	},
	{
		Brush = "zhanji_03",
		Movement0 = this.createVec(120, -90),
		Movement1 = this.createVec(-120, 90),
		Offset = this.createVec(-100, 10)
	},
	{
		Brush = ""
	},
	{
		Brush = "zhanji_04",
		Movement0 = this.createVec(-120, -90),
		Movement1 = this.createVec(120, 90),
		Offset = this.createVec(20, 10)
	},
	{
		Brush = "zhanji_04",
		Movement0 = this.createVec(-120, 90),
		Movement1 = this.createVec(120, -90),
		Offset = this.createVec(20, -40)
	}
];

::Const.Faces.WushiMale <- [
	"bust_head_wushi_01",
	"bust_head_wushi_02",
	"bust_head_wushi_03"
];

::Const.Hair.WushiMaleOnly <- [
	"01_wushi",
	"02_wushi",
	"01_wushi",
	"02_wushi",
	"01_wushi",
	"02_wushi",
	"01_wushi",
	"02_wushi",
	"01_wushi",
	"02_wushi",
	"01_wushi",
	"02_wushi"
	
];

::Const.HairColors.Wushi <- [
	"black",
	"black",
	"black",
	"black",
	"black",
	"black",
	"black",
	"black",
	"black",
	"black",
	"black",
	"black"
	
];
