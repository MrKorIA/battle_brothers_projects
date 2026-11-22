::ReforgedLite.HooksMod.hook("scripts/skills/actives/warhound_bite", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Набрасывается на врага, терзая и разрывая огромными зубами его плоть.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		return this.getDefaultTooltip();
	}}.getTooltip;
});
