// Регистрация сущностей зомби-орков: EntityType, Tactical.Actor, Spawn.Troops.
// Данные — из Reforged 0.9.3 (mod_reforged/hooks/config/faction_undead.nut).
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

//zombie orcs
addEntityType("RF_ZombieOrcYoung", "Восставший молодой орк", "восставших молодых орков", "rf_zombie_orc_young_orientation");
addEntityType("RF_ZombieOrcYoungBodyguard", "Восставший молодой орк", "восставших молодых орков", "rf_zombie_orc_young_orientation");
addEntityType("RF_ZombieOrcBerserker", "Восставший орк-берсерк", "восставших орков-берсерков", "rf_zombie_orc_berserker_orientation");
addEntityType("RF_ZombieOrcWarrior", "Восставший орк-воин", "восставших орков-воинов", "rf_zombie_orc_warrior_orientation");
addEntityType("RF_ZombieOrcWarriorBodyguard", "Восставший орк-воин", "восставших орков-воинов", "rf_zombie_orc_warrior_orientation");
addEntityType("RF_ZombieOrcWarlord", "Восставший вождь орков", "восставших вождей орков", "rf_zombie_orc_warlord_orientation");

::Const.Tactical.Actor.RF_ZombieOrcYoung <- {
    XP = 200,
    ActionPoints = 6,
    Hitpoints = 200,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 50,
    RangedSkill = 0,
    MeleeDefense = -10,
    RangedDefense = -10,
    Initiative = 60,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_ZombieOrcBerserker <- {
    XP = 300,
    ActionPoints = 7,
    Hitpoints = 350,
    Bravery = 90,
    Stamina = 100,
    MeleeSkill = 60,
    RangedSkill = 0,
    MeleeDefense = 0,
    RangedDefense = -5,
    Initiative = 60,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_ZombieOrcWarrior <- {
    XP = 350,
    ActionPoints = 7,
    Hitpoints = 300,
    Bravery = 90,
    Stamina = 100,
    MeleeSkill = 60,
    RangedSkill = 0,
    MeleeDefense = -15,
    RangedDefense = -15,
    Initiative = 60,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_ZombieOrcWarlord <- {
    XP = 450,
    ActionPoints = 7,
    Hitpoints = 600,
    Bravery = 130,
    Stamina = 100,
    MeleeSkill = 70,
    RangedSkill = 0,
    MeleeDefense = -15,
    RangedDefense = -15,
    Initiative = 60,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};

::Const.World.Spawn.Troops.RF_ZombieOrcYoung <- {
	ID = ::Const.EntityType.RF_ZombieOrcYoung,
	Variant = 0,
	Strength = 14,
	Cost = 12,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_young",
	TitleList = null
};
::Const.World.Spawn.Troops.RF_ZombieOrcYoungBodyguard <- {
	ID = ::Const.EntityType.RF_ZombieOrcYoungBodyguard,
	Variant = 0,
	Strength = 14,
	Cost = 12,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_young_bodyguard",
	TitleList = null
};
::Const.World.Spawn.Troops.RF_ZombieOrcBerserker <- {
	ID = ::Const.EntityType.RF_ZombieOrcBerserker,
	Variant = 0,
	Strength = 25,
	Cost = 20,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_berserker",
	TitleList = null
};
::Const.World.Spawn.Troops.RF_ZombieOrcWarrior <- {
	ID = ::Const.EntityType.RF_ZombieOrcWarrior,
	Variant = 0,
	Strength = 28,
	Cost = 25,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_warrior",
	TitleList = null
};
::Const.World.Spawn.Troops.RF_ZombieOrcWarriorBodyguard <- {
	ID = ::Const.EntityType.RF_ZombieOrcWarriorBodyguard,
	Variant = 0,
	Strength = 28,
	Cost = 25,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_warrior_bodyguard",
	TitleList = null
};
::Const.World.Spawn.Troops.RF_ZombieOrcWarlord <- {
	ID = ::Const.EntityType.RF_ZombieOrcWarlord,
	Variant = 0,
	Strength = 36,
	Cost = 34,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_warlord",
	TitleList = null
};
