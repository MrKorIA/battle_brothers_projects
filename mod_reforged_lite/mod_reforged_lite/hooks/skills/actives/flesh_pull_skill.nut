::ReforgedLite.HooksMod.hook("scripts/skills/actives/flesh_pull_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Используя тёмные силы, подтянуть цель к трупу или союзному мясному голему, находящемуся на расстоянии не более 3 клеток, [ошеломляя|Skill+staggered_effect] её по прибытии.");
	}}.create;

	// Overwrite, because Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});

		return ret;
	}}.getTooltip;
});
