::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/gorge_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Мощная атака, которую можно использовать на расстоянии.";
		m.Icon = "skills/active_107.png";
		m.IconDisabled = "skills/active_107_sw.png";
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] клеток"
		});
		return ret;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInAxes ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
});
