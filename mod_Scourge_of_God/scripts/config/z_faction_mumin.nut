::Const.Tactical.Actor.Mumin <- {
	XP = 150,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 50,
	RangedSkill = 50,
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

::Const.World.Spawn.Troops.Mumin <-
{
    ID = this.Const.EntityType.Mumin,
    Variant = 0,
    Strength = 30,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/mgl_mumin",
    TitleList = null
}