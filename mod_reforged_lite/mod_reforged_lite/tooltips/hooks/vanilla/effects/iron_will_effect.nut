::ReforgedLite.HooksMod.hook("scripts/skills/effects/iron_will_effect", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11)
			{
				entry.text = ::ReforgedLite.Mod.Tooltips.parseString("Не подвержен влиянию и не может получать [временные травмы|Concept.InjuryTemporary].");
				break;
			}
		}

		return ret;
	}}.getTooltip;
});
