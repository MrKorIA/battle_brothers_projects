::ReforgedLite.HooksMod.hook("scripts/skills/actives/ghastly_touch", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Поразите саму душу противника, нанося ему урон сквозь броню.";
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		return this.skill.getDefaultTooltip();
	}}.getTooltip;
});
