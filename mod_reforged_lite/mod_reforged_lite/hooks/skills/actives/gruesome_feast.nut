::ReforgedLite.HooksMod.hook("scripts/skills/actives/gruesome_feast", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Утолить голод трупом, дабы восстановиться и вырасти!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/health.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Все [ОЗ|Concept.Hitpoints] и [травмы|Concept.InjuryTemporary] полностью исцеляются")
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Персонаж получает эффект [Насыщен|Skill+gruesome_feast_effect]")
		});
		return ret;
	}}.getTooltip;
});
