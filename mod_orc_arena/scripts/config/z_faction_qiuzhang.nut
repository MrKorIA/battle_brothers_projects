::Const.Tactical.Actor.Qiuzhang <- {
	XP = 600,
	ActionPoints = 9,
	Hitpoints = 200,
	Bravery = 110,
	Stamina = 200,
	MeleeSkill = 80,
	RangedSkill = 5,
	MeleeDefense = 15,
	RangedDefense = 15,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.World.Spawn.Troops.Qiuzhang <-
	{
		ID = this.Const.EntityType.Qiuzhang,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/qiuzhang",
		TitleList = null
	}