::ReforgedLite.HooksMod.hook("scripts/skills/actives/gore_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Дух бросается вперёд с чудовищной силой, нанизывая врагов на свои огромные рога.";
	}}.create;

	// Vanilla getTooltip for this skill only has name, description and cost string
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("[Ошеломляет|Skill+staggered_effect] и [отбрасывает|Skill+knock_back] все цели вокруг целевой клетки")
		});
		return ret;
	}}.getTooltip;
});
