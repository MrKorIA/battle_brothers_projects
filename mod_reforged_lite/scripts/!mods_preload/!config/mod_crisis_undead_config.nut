// Регистрация кризисных юнитов Reforged: EntityType, Tactical.Actor, Spawn.Troops.
// Данные — из Reforged 0.9.3 (mod_reforged/hooks/config/faction_undead.nut).
// Variant в Spawn.Troops убран (в ванильном спавнере Variant>0 делает каждого бойца минибоссом —
// у Reforged это безопасно из-за их спавнера, у нас нет).
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

//crisis undead elites
addEntityType("RF_VampireLord", "Некрокультист лорд", "некрокультистов лордов", "rf_vampire_lord_orientation");
addEntityType("RF_Banshee", "Скорбная мать", "скорбных матерей", "rf_banshee_orientation");
addEntityType("RF_Hollenhund", "Адская гончая", "адских гончих", "rf_hollenhund_orientation");

::Const.Tactical.Actor.RF_VampireLord <- {
    XP = 700,
    ActionPoints = 9,
    Hitpoints = 300,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 95,
    RangedSkill = 0,
    MeleeDefense = 30,
    RangedDefense = 30,
    Initiative = 140,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_Banshee <- {
    XP = 550,
    ActionPoints = 9,
    Hitpoints = 1,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 80,
    RangedSkill = 0,
    MeleeDefense = 15,
    RangedDefense = 999,
    Initiative = 100,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_Hollenhund <- {
    XP = 400,
    ActionPoints = 12,
    Hitpoints = 150,
    Bravery = 90,
    Stamina = 100,
    MeleeSkill = 70,
    RangedSkill = 0,
    MeleeDefense = 20,
    RangedDefense = 50,
    Initiative = 110,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};

::Const.World.Spawn.Troops.RF_VampireLord <- {
	ID = ::Const.EntityType.RF_VampireLord,
	Variant = 0,
	Strength = 50,
	Cost = 50,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_vampire_lord",
	NameList = ::Const.Strings.RF_VampireLordNames,
	TitleList = ::Const.Strings.RF_VampireLordTitles
};
::Const.World.Spawn.Troops.RF_Banshee <- {
	ID = ::Const.EntityType.RF_Banshee,
	Variant = 0,
	Strength = 50,
	Cost = 50,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_banshee",
	NameList = ::Const.Strings.RF_BansheeNames,
	TitleList = ::Const.Strings.RF_BansheeTitles
};
::Const.World.Spawn.Troops.RF_Hollenhund <- {
	ID = ::Const.EntityType.RF_Hollenhund,
	Variant = 0,
	Strength = 40,
	Cost = 20,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_hollenhund",
	TitleList = null
};
