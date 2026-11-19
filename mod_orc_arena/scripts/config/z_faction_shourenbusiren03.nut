::Const.Tactical.Actor.Shourenbusiren03 <- {
	XP = 400,
	ActionPoints = 8,
	Hitpoints = 300,
	Bravery = 999,
	Stamina = 200,
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
	DamageTotalMult = 1.25
};

::Const.World.Spawn.Troops.Shourenbusiren03 <-
	{
		ID = this.Const.EntityType.Shourenbusiren03,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/shourenbusiren03",
		TitleList = null
	}