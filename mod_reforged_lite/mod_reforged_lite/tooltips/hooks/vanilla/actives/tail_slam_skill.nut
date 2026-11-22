::ReforgedLite.HooksMod.hook("scripts/skills/actives/tail_slam_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Удар хвостом с размаха, использующий всю силу для размазывания цели в месиво.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Случайным образом либо [выбьет дух|Skill+dazed_effect], либо [оглушит|Skill+stunned_effect], либо [отбросит|Skill+knock_back] цель")
			}
		]);
		return ret;
	}}.getTooltip;
});
