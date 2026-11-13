::ReforgedLite.HooksMod.hook("scripts/skills/traits/greedy_trait", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/asset_money.png",
			text = ::MSU.Text.colorNegative("15%") + " к дневному жалованию"
		});
		return ret;
	}}.getTooltip;
});
