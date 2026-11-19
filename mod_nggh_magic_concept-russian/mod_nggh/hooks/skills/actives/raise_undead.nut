::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/raise_undead", function(q)
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Вернуть к жизни труп нежити, который будет верно выполнять ваши приказы.";
		m.IconDisabled = "skills/active_26_sw.png";
	}

	q.getTooltip <- function()
	{
		return getDefaultUtilityTooltip();
	}
});
