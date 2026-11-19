::Const.Tactical.Actor.Shourenlueduozhe <- {
	XP = 500,
	ActionPoints = 10,
	Hitpoints = 200,
	Bravery = 80,
	Stamina = 200,
	MeleeSkill = 65,
	RangedSkill = 70,
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

::Const.World.Spawn.Troops.Shourenlueduozhe <-
	{
		ID = this.Const.EntityType.Shourenlueduozhe,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/shourenlueduozhe",
		TitleList = null
	}