::Const.Tactical.Actor.Shourenbusiren02 <- {
	XP = 200,
	ActionPoints = 8,
	Hitpoints = 500,
	Bravery = 999,
	Stamina = 250,
	MeleeSkill = 65,
	RangedSkill = 40,
	MeleeDefense = -20,
	RangedDefense = -20,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 30,
	DamageTotalMult = 1.35
};

::Const.World.Spawn.Troops.Shourenbusiren02 <-
	{
		ID = this.Const.EntityType.Shourenbusiren02,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/shourenbusiren02",
		TitleList = null
	}