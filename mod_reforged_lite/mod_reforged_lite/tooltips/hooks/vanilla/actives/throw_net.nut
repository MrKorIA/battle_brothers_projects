::ReforgedLite.HooksMod.hook("scripts/skills/actives/throw_net", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Применяет эффект [$ $|Skill+net_effect] к цели")
		});

		return ret;
	}}.getTooltip;
});
