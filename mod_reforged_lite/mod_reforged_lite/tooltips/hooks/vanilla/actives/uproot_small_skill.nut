::ReforgedLite.HooksMod.hook("scripts/skills/actives/uproot_small_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Колючие корни вздымаются из земли, поражая и прокалывая несколько целей.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Цель становится [ошеломленной|Skill+staggered_effect] при попадании")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не повреждает и не влияет на других леших")
			}
		]);
		return ret;
	}}.getTooltip;
});
