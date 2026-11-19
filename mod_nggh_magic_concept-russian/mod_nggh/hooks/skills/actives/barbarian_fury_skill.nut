::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/barbarian_fury_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Позволяет поменяться местами с любым союзником, находящимся рядом, если только он не оглушён или обездвижен. Всегда держите свежих бойцов в переднем ряду!";
		m.Icon = "skills/active_175.png";
		m.IconDisabled = "skills/active_175_sw.png";
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			setBaseValue("FatigueCost", 10);
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();

		if (getContainer().getActor().getCurrentProperties().IsRooted)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Нельзя использовать, пока персонаж обездвижен[/color]"
			});
		
		if (m.IsSpent)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Можно использовать только один раз за ход[/color]"
			});

		return ret;
	}

	q.getCursorForTile <- function( _tile )
	{
		return ::Const.UI.Cursor.Rotation;
	}
});
