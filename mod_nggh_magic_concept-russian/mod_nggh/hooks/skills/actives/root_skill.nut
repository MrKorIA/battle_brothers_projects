::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/root_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Высвободить из земли корни, оплетающие ваших врагов. Затраты выносливости и ОД снижаются во время дождя, а также от мастерства посоха.";
		m.Icon = "skills/active_70.png";
		m.IconDisabled = "skills/active_70_sw.png";
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			setBaseValue("FatigueCost", 20);
	}

	q.getTooltip = @() function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] клеток"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может поразить до 7 целей"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Оплетает цели лозой"
			}
		]);
		return ret;
	}

	q.onTargetSelected <- function( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		for( local i = 0; i < 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
				continue;

			local tile = _targetTile.getNextTile(i);
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}
	
});
