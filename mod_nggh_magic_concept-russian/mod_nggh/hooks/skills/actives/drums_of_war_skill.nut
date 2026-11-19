::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/drums_of_war_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Вдохновить своих людей военным ритмом.";
		m.Icon = "skills/active_163.png";
		m.IconDisabled = "skills/active_163_sw.png";
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Мгновенно снижает усталость каждого брата на [color=" + ::Const.UI.Color.NegativeValue + "]-10[/color]."
		});
		return ret;
	}
});
