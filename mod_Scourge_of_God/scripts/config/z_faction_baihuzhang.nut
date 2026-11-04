::Const.Tactical.Actor.Baihuzhang <- {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 120,
	Bravery = 100,
	Stamina = 155,
	MeleeSkill = 70,
	RangedSkill = 65,
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

::Const.World.Spawn.Troops.Baihuzhang <-
{
    ID = this.Const.EntityType.Baihuzhang,
    Variant = 3,
    Strength = 30,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/mgl_baihuzhang",
    NameList = this.Const.Strings.MglNames,
    TitleList = this.Const.Strings.MglTitles
}