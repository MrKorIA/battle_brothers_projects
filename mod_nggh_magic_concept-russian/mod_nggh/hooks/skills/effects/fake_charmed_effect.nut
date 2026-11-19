::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/fake_charmed_effect", function(q) 
{
	q.getName <- function()
	{
		return "Простак";
	}

	q.getDescription <- function()
	{
		return "Этот персонаж был очарован вами, он более не управляет своими действиями и, словно марионетка, лишён выбора, подчиняясь лишь своей прекрасной владычице, став обычным простаком, ни больше, ни меньше.";
	}

	q.getTooltip <- function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+20[/color] к решимости"
			}
		];
	}
});
