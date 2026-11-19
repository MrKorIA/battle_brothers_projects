::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/grant_night_vision_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		//m.IsMagicSkill = true;
		//m.MagicPointsCost = 1;
		//m.IsRequireStaff = true;
		m.Description = "Простое песнопение, дающее группе ваших людей способность видеть сквозь тьму ночи.";
		m.Icon = "skills/active_156.png";
		m.IconDisabled = "skills/active_156_sw.png";
		m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
		m.IsTargetingActor = false;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();

		ret.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
				text = "Снимает штрафы [color=" + ::Const.UI.Color.NegativeValue + "]ночного времени[/color] с группы союзников"
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
