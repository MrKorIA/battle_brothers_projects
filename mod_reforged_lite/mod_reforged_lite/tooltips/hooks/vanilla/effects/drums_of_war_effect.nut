::ReforgedLite.HooksMod.hook("scripts/skills/effects/drums_of_war_effect", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Накопленная [усталость|Concept.Fatigue] уменьшается на " + ::MSU.Text.colorPositive("15") + " при получении этого эффекта")
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Этот эффект можно получить не более одного раза за [ход|Concept.Turn].")
		});

		return ret;
	}}.getTooltip;
});
