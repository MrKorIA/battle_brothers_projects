::Const.Tactical.Actor.Niutoukuangzhanshi <- {
	XP = 800,
	ActionPoints = 9,
	Hitpoints = 800,
	Bravery = 180,
	Stamina = 500,
	MeleeSkill = 70,
	RangedSkill = 5,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.World.Spawn.Troops.Niutoukuangzhanshi <-
	{
		ID = this.Const.EntityType.Niutoukuangzhanshi,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/niutoukuangzhanshi",
		TitleList = null
	}