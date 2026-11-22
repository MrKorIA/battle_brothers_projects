::ReforgedLite.HooksMod.hook("scripts/skills/effects/hyena_potion_effect", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		foreach (entry in ret)
		{
			if (entry.id == 11)
			{
				entry.text = ::ReforgedLite.Mod.Tooltips.parseString("Эффект [Кровотечение|Skill+bleeding_effect] снижен " + ::MSU.Text.colorPositive("вдвое"));
				break;
			}
		}
		return ret;
	}}.getTooltip;
});
