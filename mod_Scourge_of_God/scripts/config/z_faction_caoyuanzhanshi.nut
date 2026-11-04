::Const.Tactical.Actor.Caoyuanzhanshi <- {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 100,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 60,
	RangedSkill = 60,
	MeleeDefense = 5,
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

::Const.World.Spawn.Troops.Caoyuanzhanshi <-
{
    ID = this.Const.EntityType.Caoyuanzhanshi,
    Variant = 0,
    Strength = 30,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/mgl_caoyuanzhanshi",
    TitleList = null
}