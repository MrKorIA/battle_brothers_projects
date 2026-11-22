::ReforgedLite.HooksMod.hook("scripts/skills/traits/bleeder_trait", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Description = "У этого персонажа плохо свёртывается кровь, поэтому он сильнее страдает от кровотечения, чем другие."; // "сильнее" as opposed to vanilla "дольше"
	}}.create;

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::ReforgedLite.Mod.Tooltips.parseString("Эффект [Кровотечение|Skill+bleeding_effect] увеличен " + ::MSU.Text.colorNegative("вдвое"));
				break;
			}
		}
		return ret;
	}}.getTooltip;
});
