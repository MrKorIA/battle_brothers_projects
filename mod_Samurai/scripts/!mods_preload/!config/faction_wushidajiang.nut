::Const.Tactical.Actor.Wushidajiang <- {
	XP = 450,
	ActionPoints = 9,
	Hitpoints = 170,
	Bravery = 100,
	Stamina = 155,
	MeleeSkill = 80,
	RangedSkill = 45,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

::Const.Strings.WushidajiangTitles <- ["Тайкун"]

::Const.World.Spawn.Troops.Wushidajiang <-
{
    ID = this.Const.EntityType.Wushidajiang,
    Variant = 2,
    Strength = 20,
    Cost = 40,
    Row = 1,
    Script = "scripts/entity/tactical/humans/wushidajiang",
    NameList = this.Const.Strings.WushiNames,
    TitleList = this.Const.Strings.WushidajiangTitles
}