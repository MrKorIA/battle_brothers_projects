::ReforgedLite.HooksMod.hook("scripts/skills/racial/grand_diviner_racial", function(q) {
	// Vanilla doesn't have a getTooltip function defined for this skill
	// (create-хук Reforged с removeType(Perk) не переносим — поведенческий фикс, не тултип)
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Умения [Бичевание|Skill+censer_castigate_skill] и [Удар кадилом|Skill+censer_strike] затрачивают " + ::MSU.Text.colorizeValue(this.m.APAdjust, {AddSign = true, InvertColor = true}) + " [ОД|Concept.ActionPoints]")
			}
		]);
		return ret;
	}}.getTooltip;
});
