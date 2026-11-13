::ReforgedLite.HooksMod.hook("scripts/skills/actives/golem_grapple_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Атака ближнего боя, не наносящая урона, но [обезоруживающая|Skill+disarmed_effect] цель при попадании.");
	}}.create;

	// Overwrite, because Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		return this.skill.getDefaultTooltip();
	}}.getTooltip;
});
