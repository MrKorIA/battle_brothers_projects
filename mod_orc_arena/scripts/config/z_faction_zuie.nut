::Const.Tactical.Actor.Zuie <- {
	XP = 800,
	ActionPoints = 9,
	Hitpoints = 1000,
	Bravery = 200,
	Stamina = 500,
	MeleeSkill = 65,
	RangedSkill = 5,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.World.Spawn.Troops.Zuie <-
	{
		ID = this.Const.EntityType.Zuie,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/zuie",
		TitleList = null
	}