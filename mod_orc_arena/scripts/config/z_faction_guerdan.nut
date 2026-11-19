::Const.Tactical.Actor.Guerdan <- {
	XP = 800,
	ActionPoints = 9,
	Hitpoints = 300,
	Bravery = 150,
	Stamina = 300,
	MeleeSkill = 999,
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

::Const.World.Spawn.Troops.Guerdan <-
{
    ID = this.Const.EntityType.Guerdan,
    Variant = 0,
    Strength = 10,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/enemies/guerdan",
    TitleList = null
}