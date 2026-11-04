::Const.Tactical.Actor.Guancai <- {
	XP = 150,
	ActionPoints = 1,
	Hitpoints = 1,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 0,
	RangedSkill = 0,
	MeleeDefense = -50,
	RangedDefense = -50,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.World.Spawn.Troops.Guancai <-
{
    ID = this.Const.EntityType.Guancai,
    Variant = 0,
    Strength = 30,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/guancai",
    TitleList = null
}