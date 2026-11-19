::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/teleport_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Телепортация с использованием неизвестной силы одновременно вызывает падение окружающей температуры до абсолютного нуля.";
		m.Icon = "skills/active_167.png";
		m.IconDisabled = "skills/active_167_sw.png";
		m.Overlay = "active_167";
	}

	q.onAdded <- function()
	{
		m.IsVisibleTileNeeded = ::MSU.isKindOf(getContainer().getActor(), "player");
	}

	q.onUpdate <- function( _properties )
	{
		_properties.Vision += 7;
	}

	q.onAfterUpdate <- function( _properties )
	{
		local actor = getContainer().getActor();

		if (::MSU.isKindOf(getContainer().getActor(), "player")) {
			m.ActionPointCost += 1;
			m.MaxRange -= 15;
		}
	}

	q.getTooltip = @() function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] клеток"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Создает снежные клетки и вызывает эффект 'Охлаждён' у всех, кто находится поблизости"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Телепортируется мгновенно"
			},
		]);
		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local free = getContainer().getSkillByID("actives.break_free");

		if (free != null) {
			free.setChanceBonus(2000);

			if (!free.onUse(_user, _user.getTile()))
				return false;
		}

		return __original(_user, _targetTile);
	}
	
});
