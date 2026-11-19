::Const.Tactical.Actor.Zuie02 <- {
   	XP = 500,
	ActionPoints = 8,
	Hitpoints = 300,
	Bravery = 90,
	Stamina = 250,
	MeleeSkill = 80,
	RangedSkill = 40,
	MeleeDefense = -10,
	RangedDefense = -10,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		300,
		300
	],
	FatigueRecoveryRate = 30,
	DamageTotalMult = 1.35
};

::Const.World.Spawn.Troops.Zuie02 <-
	{
		ID = this.Const.EntityType.Zuie02,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/zuie02",
		TitleList = null
	}