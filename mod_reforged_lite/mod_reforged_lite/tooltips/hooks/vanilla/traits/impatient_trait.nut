::ReforgedLite.HooksMod.hook("scripts/skills/traits/impatient_trait", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		if (true)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(1000, {AddSign = true}) + " к [инициативе|Concept.Initiative] при расчёте порядка [ходов|Concept.Turn] в первом ходу боя")
			});
		}
		return ret;
	}}.getTooltip;
});
