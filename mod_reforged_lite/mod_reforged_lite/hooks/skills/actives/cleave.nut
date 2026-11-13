::ReforgedLite.HooksMod.hook("scripts/skills/actives/cleave", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		foreach (entry in ret)
		{
			// Ванильная запись про кровотечение остаётся без изменений, слово «кровотечение» становится ссылкой
			if (entry.id == 8 && entry.text.find("Вызывает кровотечение") != null)
			{
				entry.text = ::ReforgedLite.Mod.Tooltips.parseString("[Вызывает кровотечение|Skill+bleeding_effect]" + entry.text.slice("Вызывает кровотечение".len()));
				break;
			}
		}
		return ret;
	}}.getTooltip;
});
