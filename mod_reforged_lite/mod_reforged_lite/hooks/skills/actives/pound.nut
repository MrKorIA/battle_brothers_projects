::ReforgedLite.HooksMod.hook("scripts/skills/actives/pound", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			// Improve the vanilla entry about ignoring Shields to also mention Shieldwall
			if (entry.id == 8)
			{
				entry.text = ::ReforgedLite.Mod.Tooltips.parseString(format("Игнорирует бонус к [защите в ближнем бою|Concept.MeleeDefense] от щита, но не от умения [Стена щитов|Skill+shieldwall_effect]"));
				break;
			}
		}

		return ret;
	}}.getTooltip;
});
