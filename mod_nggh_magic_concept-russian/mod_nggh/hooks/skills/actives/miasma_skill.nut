::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/miasma_skill", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Выпускает облако ядовитых газов, которые отравляет живых существ. Облако действует не менее 3-х ходов.";
		m.Icon = "skills/active_101.png";
		m.IconDisabled = "skills/active_101_sw.png";
		m.Order =  ::Const.SkillOrder.UtilityTargeted + 3;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player")) // huge nerf for player
			setBaseValue("FatigueCost", 25);
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" +  ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] клеток"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "Наносит [color=" + ::Const.UI.Color.DamageValue + "]5[/color] - [color=" + ::Const.UI.Color.DamageValue + "]10[/color] урона от яда каждый ход"
			}
		]);

		return ret;
	}

	q.onTargetSelected <- function( _targetTile )
	{
		local ownTile = _targetTile;

		for( local i = 0; i != 6; ++i )
		{
			if (!ownTile.hasNextTile(i))
				continue;

			local tile = ownTile.getNextTile(i);

			if ( ::Math.abs(tile.Level - ownTile.Level) <= 1)
				 ::Tactical.getHighlighter().addOverlayIcon( ::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}
	
});
