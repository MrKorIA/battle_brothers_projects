::ReforgedLite.HooksMod.hook("scripts/skills/actives/throw_smoke_bomb_skill", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		foreach (index, entry in ret)
		{
			// Vanilla has two entries with id 5. That's why we check for a phrase aswell
			if (entry.id == 5 && entry.text.find("Увеличивает защиту в дальнем бою на ") != null)
			{
				ret.remove(index);	// We remove that entry because we want to split it into two seperate entries that are next to each other
				break;
			}
		}

		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("50%") + " к [навыку дальнего боя|Concept.RangeSkill] для стоящих в дыму")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+30") + " к [защите в дальнем бою|Concept.RangeDefense] для стоящих в дыму")
			}
		]);

		return ret;
	}}.getTooltip;
});
