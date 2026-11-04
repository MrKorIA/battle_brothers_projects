::Const.Tactical.Actor.Lingmuyouling <- {
	XP = 150,
	ActionPoints = 12,
	Hitpoints = 1,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 70,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 999,
	Initiative = 150,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.World.Spawn.Troops.Lingmuyouling <-
{
    ID = this.Const.EntityType.Lingmuyouling,
    Variant = 0,
    Strength = 30,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/lingmuyouling",
    TitleList = null
}