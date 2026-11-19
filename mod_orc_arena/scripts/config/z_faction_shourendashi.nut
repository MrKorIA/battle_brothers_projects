::Const.Tactical.Actor.Shourendashi <- {
	XP = 800,
	ActionPoints = 8,
	Hitpoints = 350,
	Bravery = 90,
	Stamina = 250,
	MeleeSkill = 85,
	RangedSkill = 40,
	MeleeDefense = -10,
	RangedDefense = -10,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 30,
	DamageTotalMult = 1.35
};

::Const.World.Spawn.Troops.Shourendashi <-
	{
		ID = this.Const.EntityType.Shourendashi,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/shourendashi",
		TitleList = null
	}