::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/lindwurm_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Кислотная кровь";
		m.Description = "Кровь этого чудовища крайне опасна, она способна разъесть большинство доспехов.";
		m.Icon = "skills/status_effect_78.png";
		m.IconMini = "status_effect_78_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First;
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
				icon = "ui/icons/special.png",
				text = "Брызгает кислотной кровью на нападающего в ближнем бою"
			}
		];
	}
	
});
