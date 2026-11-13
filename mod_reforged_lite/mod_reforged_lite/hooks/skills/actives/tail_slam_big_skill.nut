::ReforgedLite.HooksMod.hook("scripts/skills/actives/tail_slam_big_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla has the name Tail Slam for this skill which is the same as the name for tail_slam_skill
		// We give it a unique name to help differentiate the two skills
		this.m.Name = "Удар хвостом";
		// Vanilla is missing a description for this skill
		this.m.Description = "Безрассудно вращающийся хвост молотит всех вокруг: и врагов и друзей.";
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
