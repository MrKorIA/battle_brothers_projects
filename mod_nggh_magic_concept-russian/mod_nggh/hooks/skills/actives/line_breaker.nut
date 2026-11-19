::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/line_breaker", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Использовать грубую силу для отбрасывания цели в сторону, чтобы продвинуться вперёд. Можно использовать на союзниках.";
		m.Icon = "skills/active_53.png";
		m.IconDisabled = "skills/active_53_sw.png";
		m.IsAttack = false;
	}

	q.onAdded <- function()
	{
		local AI = getContainer().getActor().getAIAgent();

		if (AI.getID() != ::Const.AI.Agent.ID.Player)
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_line_breaker"));
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Отбрасывает цель в сторону и занимает её место"
		});

		return ret;
	}
});
