::ReforgedLite.HooksMod.hook("scripts/skills/actives/wither_skill", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель становится [иссушенной|Skill+withered_effect]")
		});
		return ret;
	}}.getTooltip;
});
