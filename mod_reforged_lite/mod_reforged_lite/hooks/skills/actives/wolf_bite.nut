::ReforgedLite.HooksMod.hook("scripts/skills/actives/wolf_bite", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Набрасывается на врага, терзая и разрывая зубами его плоть.";
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		return this.getDefaultTooltip();
	}}.getTooltip;
});
