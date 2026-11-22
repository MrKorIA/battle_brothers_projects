::ReforgedLite.HooksMod.hook("scripts/skills/traits/disloyal_trait", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/asset_money.png",
			text = ::MSU.Text.colorNegative("100%") + " к шансу дезертировать при плохом настроении"
		});
		return ret;
	}}.getTooltip;
});
