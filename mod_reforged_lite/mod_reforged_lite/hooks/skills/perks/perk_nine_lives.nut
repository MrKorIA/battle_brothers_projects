::ReforgedLite.HooksMod.hook("scripts/skills/perks/perk_nine_lives", function(q) {
	q.getDescription = @() { function getDescription()
	{
		return ::ReforgedLite.Mod.Tooltips.parseString("Один раз за бой, получив смертельный удар, этот персонаж выживет с несколькими [ОЗ|Concept.Hitpoints]. Все отрицательные [эффекты|Concept.StatusEffect], наносящие урон (отравление, кровотечение), при этом излечиваются, а его [защита в ближнем бою|Concept.MeleeDefense], [защита в дальнем бою|Concept.RangeDefense], [решимость|Concept.Bravery] и [инициатива|Concept.Initiative] увеличиваются до начала следующего [хода|Concept.Turn] персонажа.");
	}}.getDescription;
});
