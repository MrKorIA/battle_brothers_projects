::Const.Tactical.Actor.Shourenbusiren04 <- {
	XP = 400,
	ActionPoints = 8,
	Hitpoints = 200,
	Bravery = 75,
	Stamina = 200,
	MeleeSkill = 70,
	RangedSkill = 40,
	MeleeDefense = -10,
	RangedDefense = -10,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		300,
		300
	],
	FatigueRecoveryRate = 30,
	DamageTotalMult = 1.25
};

::Const.World.Spawn.Troops.Shourenbusiren04 <-
	{
		ID = this.Const.EntityType.Shourenbusiren04,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/shourenbusiren04",
		TitleList = null
	}