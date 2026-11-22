::ReforgedLite.HooksMod.hook("scripts/skills/actives/recover_skill", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Устанавливает значение [ОД|Concept.ActionPoints] на " + ::MSU.Text.colorNegative(0) + " и завершает [ход|Concept.Turn]")
		});

		return ret;
	}}.getTooltip;
});
