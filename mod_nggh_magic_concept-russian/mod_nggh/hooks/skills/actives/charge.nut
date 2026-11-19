::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/charge", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Бросайтесь на врагов и бейте их своим телом гугемунгуса.";
		m.Icon = "skills/active_52.png";
		m.IconDisabled = "skills/active_52_sw.png";
	}

	q.onAdded <- function()
	{
		local AI = getContainer().getActor().getAIAgent();

		if (AI.getID() == ::Const.AI.Agent.ID.Player)
			setBaseValue("FatigueCost", 30);
		else {
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_charge"));
			AI.m.Properties.EngageRangeMin = 1;
			AI.m.Properties.EngageRangeMax = 2;
			AI.m.Properties.EngageRangeIdeal = 2;
		}
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] клеток"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Шанс [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] оглушить противника"
			}
		])

		if (m.IsSpent)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Можно использовать только один раз за ход[/color]"
			});

		return ret;
	}
	
});
