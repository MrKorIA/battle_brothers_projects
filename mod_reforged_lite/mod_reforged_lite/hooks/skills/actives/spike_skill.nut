::ReforgedLite.HooksMod.hook("scripts/skills/actives/spike_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Мощная колющая атака ближнего боя, поражающая до трёх врагов в линию.");
	}}.create;

	// Overwrite, because Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		return this.skill.getDefaultTooltip();
	}}.getTooltip;
});
