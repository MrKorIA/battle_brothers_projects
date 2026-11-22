::ReforgedLite.HooksMod.hook("scripts/skills/traits/brute_trait", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		foreach(entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/chance_to_hit_head.png")
			{
				entry.text = "Наносит на " + ::MSU.Text.colorPositive("15%") + " больше урона в ближнем бою при попадании в голову";
				break;
			}
		}
		return ret;
	}}.getTooltip;
});
