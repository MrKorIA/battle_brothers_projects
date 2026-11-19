::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/skeleton_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Невосприимчив к дальнобойным атакам";
		m.Description = "Колющие и дальнобойные атаки малоэффективны против этого персонажа.";
		m.Icon = "ui/perks/perk_32.png";
		m.IconMini = "perk_32_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.getTooltip <- function()
	{
		local ret = [
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
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчив[/color] к колющему, огненному и дальнобойному урону"
			}
		];

		if ("Assets" in ::World && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Наносит на [color=" + ::Const.UI.Color.PositiveValue + "]25%[/color] меньше урона по ОЗ"
			});

		return ret;
	}
	
});
