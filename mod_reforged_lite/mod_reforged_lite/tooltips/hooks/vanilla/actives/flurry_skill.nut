::ReforgedLite.HooksMod.hook("scripts/skills/actives/flurry_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Непредсказуемая дробящая атака ближнего боя, которая содержит шесть ударов, равномерно распределяя их между всеми рядом стоящими противниками.");
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		return this.skill.getDefaultTooltip();
	}}.getTooltip;
});
