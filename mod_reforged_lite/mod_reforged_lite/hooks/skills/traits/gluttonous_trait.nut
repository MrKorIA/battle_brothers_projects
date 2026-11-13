::ReforgedLite.HooksMod.hook("scripts/skills/traits/gluttonous_trait", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/asset_daily_food.png",
			text = "Потребляет " + ::MSU.Text.colorNegative("+1") + " еды в день"
		})

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/asset_daily_food.png",
			text = "На " + ::MSU.Text.colorNegative("100%") + " быстрее теряет настроение из-за голодания"
		});

		return ret;
	}}.getTooltip;
});
