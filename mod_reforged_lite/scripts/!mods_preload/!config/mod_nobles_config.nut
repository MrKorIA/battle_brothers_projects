// Регистрация «защитника герольда» (Royal Guard) — данных из Reforged 0.9.3
// (mod_reforged/hooks/config/faction_military.nut). Использует rf_heraldic_cape_upgrade.
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

addEntityType("RF_HeraldsBodyguard", "Защитник герольда", "защитников герольда", "rf_heralds_bodyguard_orientation");

::Const.Tactical.Actor.RF_HeraldsBodyguard <- {
    XP = 475,
    ActionPoints = 9,
    Hitpoints = 120,
    Bravery = 90,
    Stamina = 140,
    MeleeSkill = 90,
    RangedSkill = 60,
    MeleeDefense = 20,
    RangedDefense = 0,
    Initiative = 130,
    FatigueEffectMult = 1.0,
    MoraleEffectMult = 1.0,
    Armor = [
        0,
        0
    ],
    FatigueRecoveryRate = 15
};

::Const.World.Spawn.Troops.RF_HeraldsBodyguard <- {
	ID = ::Const.EntityType.RF_HeraldsBodyguard,
	Variant = 0,
	Strength = 40,
	Cost = 30,
	Row = 2,
	Script = "scripts/entity/tactical/humans/rf_heralds_bodyguard",
	TitleList = null
};
