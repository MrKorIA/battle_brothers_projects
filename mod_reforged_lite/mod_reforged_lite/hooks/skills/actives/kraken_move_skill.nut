::ReforgedLite.HooksMod.hook("scripts/skills/actives/kraken_move_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Перемещает щупальце с одного места на другое.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		return this.skill.getDefaultUtilityTooltip();
	}}.getTooltip;
});
