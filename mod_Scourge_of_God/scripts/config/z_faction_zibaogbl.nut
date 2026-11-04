::Const.Tactical.Actor.Zibaogbl <- {
	XP = 450,
	ActionPoints = 9,
	Hitpoints = 20,
	Bravery = 100,
	Stamina = 150,
	MeleeSkill = 70,
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

::Const.World.Spawn.Troops.Zibaogbl <-
{
    ID = this.Const.EntityType.Zibaogbl,
    Variant = 0,
    Strength = 30,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/zibaogbl",
    TitleList = null
}