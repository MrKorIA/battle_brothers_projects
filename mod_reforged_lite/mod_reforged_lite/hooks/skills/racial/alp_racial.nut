::ReforgedLite.HooksMod.hook("scripts/skills/racial/alp_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Получает на " + ::MSU.Text.colorNegative("50%") + " меньше колющего урона в ближнем бою"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "Получает на " + ::MSU.Text.colorNegative("90%") + " меньше урона от выстрелов из лука, на " + ::MSU.Text.colorNegative("66%") + " меньше - от арбалетов и пращи, на " + ::MSU.Text.colorNegative("75%") + " меньше - от метательных копий"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Получает на " + ::MSU.Text.colorNegative("66%") + " меньше урона от собак и волков"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/health.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Каждый раз, когда этот персонаж получает урон по [ОЗ|Concept.Hitpoints], все альпы телепортируются в новые случайные места рядом со своими жертвами")
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к эффекту [Ночное время|Skill+night_effect]")
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не подвержен влиянию и не может получать [временные травмы|Concept.InjuryTemporary].")
			},
			{
				id = 22,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [кровотечению|Skill+bleeding_effect]")
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [отравлению|Skill+spider_poison_effect]")
			},
			{
				id = 24,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к отталкиванию и захвату"
			},
			{
				id = 25,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [обезоруживанию|Skill+disarmed_effect]")
			}
		]);
		return ret;
	}}.getTooltip;
});
