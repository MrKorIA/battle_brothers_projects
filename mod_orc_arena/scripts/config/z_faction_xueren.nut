::Const.Tactical.Actor.Xueren <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 50,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 95,
	RangedSkill = 0,
	MeleeDefense = 25,
	RangedDefense = 0,
	Initiative = 75,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		50,
		50
	]
};

::Const.World.Spawn.Troops.Xueren <-
	{
		ID = this.Const.EntityType.Xueren,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/xueren",
		TitleList = null
	}