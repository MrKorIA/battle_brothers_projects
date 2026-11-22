::ReforgedLite.HooksMod.hook("scripts/skills/racial/skeleton_racial", function(q) {
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
				text = "Получает на " + ::MSU.Text.colorNegative("66%") + " меньше колющего урона в дальнем бою"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/campfire.png",
				text = "Получает на " + ::MSU.Text.colorNegative("66%") + " меньше урона от огня"
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
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не получает [временные травмы|Concept.InjuryTemporary]")
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
				icon = "ui/icons/morale.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не подвержен влиянию эффектов [боевого духа|Concept.Morale]")

			}
		]);
		return ret;
	}}.getTooltip;
});
