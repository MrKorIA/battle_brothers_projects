::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_stollwurm_move_tail_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.ID = "actives.move_tail";
		m.Name = "Зарыть хвост";
		m.Description = "Прокопать себе путь под землей, чтобы добраться до места назначения.";
		m.Icon = "skills/active_149.png";
		m.IconDisabled = "skills/active_149_sw.png";
		m.Overlay = "active_149";
	}

	q.getTooltip <- function()
	{
		return getDefaultUtilityTooltip();
	}
	
});
