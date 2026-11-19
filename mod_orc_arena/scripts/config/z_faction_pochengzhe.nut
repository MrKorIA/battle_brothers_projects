::Const.Tactical.Actor.Pochengzhe <- {
	XP = 550,
	ActionPoints = 9,
	Hitpoints = 150,
	Bravery = 95,
	Stamina = 170,
	MeleeSkill = 85,
	RangedSkill = 50,
	MeleeDefense = -5,
	RangedDefense = -5,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 25,
	DamageTotalMult = 1.15
};

::Const.World.Spawn.Troops.Pochengzhe <-
{
    ID = this.Const.EntityType.Pochengzhe,
    Variant = 0,
    Strength = 10,
    Cost = 15,
    Row = 3,
    Script = "scripts/entity/tactical/enemies/pochengzhe",
    TitleList = null
}