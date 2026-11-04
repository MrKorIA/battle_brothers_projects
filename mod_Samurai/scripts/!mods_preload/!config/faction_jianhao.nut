::Const.Tactical.Actor.Jianhao <- {
	XP = 550,
	ActionPoints = 9,
	Hitpoints = 130,
	Bravery = 100,
	Stamina = 145,
	MeleeSkill = 90,
	RangedSkill = 35,
	MeleeDefense = 60,
	RangedDefense = 20,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Strings.JianhaoTitles <- ["Кэнсэй"];

::Const.World.Spawn.Troops.Jianhao <-
{
    ID = this.Const.EntityType.Jianhao,
    Variant = 2,
    Strength = 20,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/jianhao",
    NameList = this.Const.Strings.WushiNames,
    TitleList = this.Const.Strings.JianhaoTitles
}