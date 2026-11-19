::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/unstoppable_charge_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "С невероятной скоростью несётся вперед и таранит вражеский строй. Может отбросить противника назад, оглушить и нанести урон. Нельзя использовать в ближнем бою.";
		m.Icon = "skills/active_110.png";
		m.IconDisabled = "skills/active_110_sw.png";
	}

	q.getTooltip = @() function()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] клеток"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может [color=" + ::Const.UI.Color.PositiveValue + "]оглушить[/color] или [color=" + ::Const.UI.Color.PositiveValue + "]оттолкнуть[/color] ближайших противников"
			}
		]);
		
		if (::Tactical.isActive() && getContainer().getActor().isEngagedInMelee())
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Нельзя использовать, потому что этот персонаж вовлечён в ближний бой[/color]"
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

	q.onCombatFinished = @() function() 
	{
		m.IsSpent = false;
	}
	
});
