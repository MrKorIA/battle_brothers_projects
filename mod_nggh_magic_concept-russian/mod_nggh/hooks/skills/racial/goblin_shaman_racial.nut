::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/goblin_shaman_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Перехват инициативы";
		m.Description = "Высокий шанс действовать первым в начале каждого боя.";
		m.Icon = "skills/status_effect_34.png";
		m.IconMini = "status_effect_34_mini";
		m.Overlay = "status_effect_34";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
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
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]+100[/color] к инициативе в первый ход"
			}
		];
	}

	q.onUpdate = @() function( _properties )
	{	
		if (::Tactical.isActive() && ::Time.getRound() <= 1)
			_properties.InitiativeForTurnOrderAdditional += 100;
	}

});
