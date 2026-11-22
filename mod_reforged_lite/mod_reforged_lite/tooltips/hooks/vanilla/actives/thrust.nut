::ReforgedLite.HooksMod.hook("scripts/skills/actives/thrust", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		if (this.getHitChanceModifier() != 0)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "" + ::MSU.Text.colorizeValue(this.getHitChanceModifier(), {AddSign = true, AddPercent = true}) + " к шансу на попадание"
			});
		}
		return ret;
	}}.getTooltip;
});
