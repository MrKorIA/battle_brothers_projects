::ReforgedLite.HooksMod.hook("scripts/skills/racial/vampire_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Исцеляет [ОЗ|Concept.Hitpoints] на " + ::MSU.Text.colorPositive("100%") + " урона, нанесенного врагам ")
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
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не подвержен влиянию и не может получать [временные травмы|Concept.InjuryTemporary]")
			},
			{
				id = 22,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [отравлению|Skill+spider_poison_effect]")
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/morale.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не подвержен влиянию эффектов [боевого духа|Concept.Morale]")
			}
		]);
		return ret;
	}}.getTooltip;
});
