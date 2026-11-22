::ReforgedLite.HooksMod.hook("scripts/skills/effects/smoke_effect", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		foreach (entry in ret)
		{
			if (entry.id == 12 && entry.icon == "ui/icons/ranged_defense.png")
			{
				// We replace a single line of the vanilla tooltip without touching the rest
				entry.text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+100%") + " к [защите в дальнем бою|Concept.RangeDefense]");
				break;
			}
		}
		return ret;
	}}.getTooltip;
});
