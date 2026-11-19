::Const.Tactical.Actor.Balian <- {
	XP = 850,
	ActionPoints = 10,
	Hitpoints = 130,
	Bravery = 100,
	Stamina = 150,
	MeleeSkill = 100,
	RangedSkill = 50,
	MeleeDefense = 60,
	RangedDefense = 15,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.World.Spawn.Troops.Balian <-
{
    ID = this.Const.EntityType.Balian,
    Variant = 0,
    Strength = 10,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/enemies/balian",
    TitleList = null
}