::ReforgedLite.HooksMod.hook("scripts/skills/actives/zombie_bite", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Наносит болезненный укус гнилыми зубами.";
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		return this.getDefaultTooltip();
	}}.getTooltip;
});
