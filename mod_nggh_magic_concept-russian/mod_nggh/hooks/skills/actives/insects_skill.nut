::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/insects_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		//m.IsMagicSkill = true;
		//m.MagicPointsCost = 6;
		//m.IsRequireStaff = true;
		m.Description = "Вызовите рой насекомых, чтобы они роились вокруг цели. Надеюсь, это рой тараканов. Нельзя использовать в ближнем бою.";
		m.Icon = "skills/active_69.png";
		m.IconDisabled = "skills/active_69_sw.png";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		ret.insert(3, {
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] клеток"
		});

		if (::Tactical.isActive() && getContainer().getActor().isEngagedInMelee())
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Нельзя использовать, пока этот персонаж вовлечён в ближний бой[/color]"
			});
		
		return ret;
	}
	
});
