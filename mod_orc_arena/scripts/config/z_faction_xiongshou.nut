::Const.Tactical.Actor.Xiongshou <- {
	XP = 500,
	ActionPoints = 12,
	Hitpoints = 600,
	Bravery = 150,
	Stamina = 500,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = 0,
	Initiative = 150,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		50,
		50
	]
};

::Const.World.Spawn.Troops.Xiongshou <-
	{
		ID = this.Const.EntityType.Xiongshou,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/xiongshou",
		TitleList = null
	}