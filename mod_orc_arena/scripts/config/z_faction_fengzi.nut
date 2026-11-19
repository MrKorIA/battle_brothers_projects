::Const.Tactical.Actor.Fengzi <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 200,
	Bravery = 100,
	Stamina = 200,
	MeleeSkill = 75,
	RangedSkill = 30,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 35,
	DamageTotalMult = 1.2
};

::Const.World.Spawn.Troops.Fengzi <-
	{
		ID = this.Const.EntityType.Fengzi,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/fengzi",
		TitleList = null
	}