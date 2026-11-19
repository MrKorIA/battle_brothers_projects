::Const.Tactical.Actor.Busiren02 <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 50,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 40,
	RangedSkill = 0,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 75,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		50,
		50
	]
};

::Const.World.Spawn.Troops.Busiren02 <-
{
    ID = this.Const.EntityType.Busiren02,
    Variant = 0,
    Strength = 10,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/enemies/busiren02",
    TitleList = null
}