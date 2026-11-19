::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/throw_dirt_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Честная игра не всегда приносит победу, а небольшой грязный трюк может легко увеличить шансы на победу. Дикий кочевник использует песчаную атаку!!!";
		m.Icon = "skills/active_215.png";
		m.IconDisabled = "skills/active_215_sw.png";
		m.IsUsingHitchance = false;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Бросает грязь или песок в лицо противника"
		});
		return ret;
	}

	q.isUsable = @() function()
	{
		return skill.isUsable();
	}

	q.onAfterUpdate <- function( _properties )
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			m.FatigueCost += 7;
	}

});
