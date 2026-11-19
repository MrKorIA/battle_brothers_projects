::Const.Tactical.Actor.Zhanzhengjiqi <- {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 70,
	Stamina = 120,
	MeleeSkill = 60,
	RangedSkill = 5,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		300,
		0
	],
	FatigueRecoveryRate = 15
};

::Const.World.Spawn.Troops.Zhanzhengjiqi <-
	{
		ID = this.Const.EntityType.Zhanzhengjiqi,
		Variant = 0,
		Strength = 10,
		Cost = 15,
		Row = 3,
		Script = "scripts/entity/tactical/enemies/zhanzhengjiqi",
		TitleList = null
	}