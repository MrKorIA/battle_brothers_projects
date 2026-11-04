::Const.Tactical.Actor.Kehanweishi <- {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 120,
	Bravery = 100,
	Stamina = 155,
	MeleeSkill = 70,
	RangedSkill = 70,
	MeleeDefense = 15,
	RangedDefense = 5,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.World.Spawn.Troops.Kehanweishi <-
{
    ID = this.Const.EntityType.Kehanweishi,
    Variant = 3,
    Strength = 30,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/mgl_kehanweishi",
    NameList = this.Const.Strings.MglNames,
    TitleList = this.Const.Strings.MglTitles
}