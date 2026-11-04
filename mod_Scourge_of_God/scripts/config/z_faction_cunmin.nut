::Const.Tactical.Actor.Cunmin <- {
	XP = 150,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 50,
	RangedSkill = 0,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.World.Spawn.Troops.Cunmin <-
{
    ID = this.Const.EntityType.Cunmin,
    Variant = 0,
    Strength = 30,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/cunmin",
    TitleList = null
}