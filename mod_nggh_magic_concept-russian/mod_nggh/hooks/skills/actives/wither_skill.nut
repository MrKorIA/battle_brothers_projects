::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/wither_skill", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Ослабляет цель на три хода, снижая её урон, усталость и инициативу на [color=" + Const.UI.Color.NegativeValue + "]-30%[/color]. Эффект ослабевает на 10% каждый ход.";
		m.IconDisabled = "skills/active_217_sw.png";
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
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Действует только на живых существ"
			},
		]);
		return ret;
	}

	q.onVerifyTarget <- function( _originTile, _targetTile )
	{
		return skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getFlags().has("undead");
	}
	
});
