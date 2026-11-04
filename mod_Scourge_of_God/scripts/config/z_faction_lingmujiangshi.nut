::Const.Tactical.Actor.Lingmujiangshi <- {
	XP = 150,
	ActionPoints = 7,
	Hitpoints = 230,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 60,
	RangedSkill = 50,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		180,
		180
	],
	FatigueRecoveryRate = 20
};

::Const.World.Spawn.Troops.Lingmujiangshi <-
{
    ID = this.Const.EntityType.Lingmujiangshi,
    Variant = 0,
    Strength = 30,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/humans/lingmujiangshi",
    TitleList = null
}