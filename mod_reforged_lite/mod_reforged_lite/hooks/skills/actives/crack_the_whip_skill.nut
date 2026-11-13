::ReforgedLite.HooksMod.hook("scripts/skills/actives/crack_the_whip_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Хлестнуть кнутом, дабы держать диких питомцев в послушании.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Не позволит питомцам выйти из повиновения во время их следующего [хода|Concept.Turn]")
		});
		return ret;
	}}.getTooltip;
});
