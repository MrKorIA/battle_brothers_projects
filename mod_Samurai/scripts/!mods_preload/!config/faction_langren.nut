::Const.Tactical.Actor.Langren <- {
	XP = 450,
	ActionPoints = 9,
	Hitpoints = 100,
	Bravery = 100,
	Stamina = 145,
	MeleeSkill = 100,
	RangedSkill = 45,
	MeleeDefense = 30,
	RangedDefense = 10,
	Initiative = 140,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Strings.LangrenTitles <- ["Ронин"];

::Const.World.Spawn.Troops.Langren <-
{
    ID = this.Const.EntityType.Langren,
    Variant = 2,
    Strength = 20,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/langren",
    NameList = this.Const.Strings.WushiNames,
    TitleList = this.Const.Strings.LangrenTitles
}