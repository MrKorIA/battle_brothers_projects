::ReforgedLite.HooksMod.hook("scripts/skills/actives/lesser_flesh_golem_attack_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Тупая дробящая ближнего боя, которая [выбивает дух|Skill+dazed_effect] из цели при попадании, если у неё нет невосприимчивости к [оглушению|Skill+stunned_effect].");
	}}.create;

	// Overwrite, because Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		return this.skill.getDefaultTooltip();
	}}.getTooltip;
});
