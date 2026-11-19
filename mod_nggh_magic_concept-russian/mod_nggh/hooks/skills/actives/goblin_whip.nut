::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/goblin_whip", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Хлыст!";
		m.Description = "Хлестнуть своих воинов гоблинов, чтобы напомнить им, кто здесь хозяин. Не сдаваться!";
		m.Icon = "skills/active_72.png";
		m.IconDisabled = "skills/active_72_sw.png";
		m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
		m.IsWeaponSkill = false;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			setBaseValue("FatigueCost", 11);
	}

	q.getTooltip <- function()
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
				text = "Восстанавливает боевой дух [color=" + ::Const.UI.Color.DamageValue + "]гоблина[/color] до 'Уверенного', если в данный момент он ниже"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снимает эффект 'Сон' с выбранного гоблина"
			}
		]);

		return ret;
	}

	q.onDelayedEffect = @(__original) function( _target )
	{
		_target.getSkills().removeByID("effects.sleeping");
		__original(_target);
	}
});
