::ReforgedLite.HooksMod.hook("scripts/skills/actives/greater_flesh_golem_attack_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Тяжёлая тупая атака ближнего боя, которая [оглушает|Skill+stunned_effect] цель при попадании.");
	}}.create;

	// Overwrite, because Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		return this.skill.getDefaultTooltip();
	}}.getTooltip;
});
