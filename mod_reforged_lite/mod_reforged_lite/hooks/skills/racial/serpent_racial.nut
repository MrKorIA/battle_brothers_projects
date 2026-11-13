::ReforgedLite.HooksMod.hook("scripts/skills/racial/serpent_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 12,
				type = "text",
				icon = "ui/icons/campfire.png",
				text = "Получает на " + ::MSU.Text.colorNegative("33%") + " меньше урона от огня"
			},
			/*{
				id = 13,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "Инициатива при расчёте очерёдности действий увеличивается на 15, если поблизости есть противник, которого можно захватить"
			}*/
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к эффекту [Ночное время|Skill+night_effect]")
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [обезоруживанию|Skill+disarmed_effect]")
			}
		]);
		return ret;
	}}.getTooltip;
});
