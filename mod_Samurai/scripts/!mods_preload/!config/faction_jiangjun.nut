::Const.Tactical.Actor.Jiangjun <- {
	XP = 550,
	ActionPoints = 9,
	Hitpoints = 150,
	Bravery = 100,
	Stamina = 145,
	MeleeSkill = 90,
	RangedSkill = 45,
	MeleeDefense = 20,
	RangedDefense = 10,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Strings.JiangjunTitles <- ["Сёгун"];

::Const.World.Spawn.Troops.Jiangjun <-
{
    ID = this.Const.EntityType.Jiangjun,
    Variant = 2,
    Strength = 20,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/jiangjun",
    NameList = this.Const.Strings.WushiNames,
    TitleList = this.Const.Strings.JiangjunTitles
}