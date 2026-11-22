::ReforgedLite.HooksMod.hook("scripts/skills/racial/schrat_racial", function(q) {
	q.getName = @() { function getName()
	{
		if (this.getContainer().getActor().isArmedWithShield()) return (this.skill.getName() + " (защищён щитом)");
		return this.skill.getName();
	}}.getName;

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Получает на " + ::MSU.Text.colorNegative("50%") + " меньше урона от метательных копий"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "Получает на " + ::MSU.Text.colorNegative("75%") + " меньше колющего урона в дальнем бою от выстрелов"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/campfire.png",
				text = "Получает на " + ::MSU.Text.colorNegative("200%") + " больше урона от огня"
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
			},
			{
				id = 26,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [обездвиживанию|Concept.Rooted]")
			},
			{
				id = 27,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [оглушению|Skill+stunned_effect]")
			}
		]);
		if (this.getContainer().getActor().isArmedWithShield())
		{
			ret.push({
				id = 30,
				type = "text",
				icon = "skills/status_effect_86.png",
				text = ::MSU.Text.colorNegative("70%") + " к получаемому урону, пока персонаж защищён щитом"
			})
		}
		return ret;
	}}.getTooltip;
});
