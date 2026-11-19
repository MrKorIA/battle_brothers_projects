::Const.Tactical.Actor.Daqiuzhang <- {
	XP = 800,
	ActionPoints = 9,
	Hitpoints = 400,
	Bravery = 90,
	Stamina = 280,
	MeleeSkill = 80,
	RangedSkill = 40,
	MeleeDefense = -20,
	RangedDefense = -20,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 30,
	DamageTotalMult = 1.35
};

::Const.World.Spawn.Troops.Daqiuzhang <-
{
    ID = this.Const.EntityType.Daqiuzhang,
    Variant = 0,
    Strength = 10,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/enemies/daqiuzhang",
    TitleList = null
}