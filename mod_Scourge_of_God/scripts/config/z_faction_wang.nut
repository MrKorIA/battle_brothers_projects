::Const.Tactical.Actor.Wang <- {
	XP = 150,
	ActionPoints = 9,
	Hitpoints = 500,
	Bravery = 80,
	Stamina = 1000,
	MeleeSkill = 65,
	RangedSkill = 0,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 65,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		500,
		500
	],
	FatigueRecoveryRate = 20
};

::Const.World.Spawn.Troops.Wang <-
{
    ID = this.Const.EntityType.Wang,
    Variant = 0,
    Strength = 30,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/wang",
    TitleList = null
}