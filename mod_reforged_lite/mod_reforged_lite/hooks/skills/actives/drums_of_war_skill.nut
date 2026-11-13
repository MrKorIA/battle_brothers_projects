::ReforgedLite.HooksMod.hook("scripts/skills/actives/drums_of_war_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Играет бодрую мелодию, даруя союзникам прилив сил и готовность к бою.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Каждый другой союзник на поле боя получает эффект [Песнь войны|Skill+drums_of_war_effect]")
		});
		return ret;
	}}.getTooltip;
});
