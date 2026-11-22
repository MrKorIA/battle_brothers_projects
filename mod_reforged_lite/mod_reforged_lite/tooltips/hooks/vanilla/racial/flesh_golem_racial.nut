::ReforgedLite.HooksMod.hook("scripts/skills/racial/flesh_golem_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/asset_medicine.png",	// This is not an ideal icon but more unique than special, and at least closely related
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(0.7) + " к [порогу нанесения травмы|Concept.InjuryThreshold]")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Перемещение затрачивает " + ::MSU.Text.colorizeValue(2, {AddSign = true, InvertColor = true}) + ::ReforgedLite.Mod.Tooltips.parseString(" [ОД|Concept.ActionPoints] за клетку")
			}
		]);
		return ret;
	}}.getTooltip;
});
