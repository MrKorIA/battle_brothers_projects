::ReforgedLite.HooksMod.hook("scripts/skills/traits/spartan_trait", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/asset_daily_food.png",
			text = "Потребляет на " + ::MSU.Text.colorPositive("-1") + " меньше провизии ежедневно"
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/asset_daily_food.png",
			text = "На " + ::MSU.Text.colorPositive("50%") + " медленнее теряет настроение из-за голодания"
		});

		return ret;
	}}.getTooltip;
});
