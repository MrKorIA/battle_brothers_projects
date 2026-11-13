::ReforgedLite.HooksMod.hook("scripts/skills/actives/sweep_zoc_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Бьёт кулаком пытающегося [отойти|Concept.ZoneOfControl] персонажа.");
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Накладывает на цель эффект [Ошеломление|Skill+staggered_effect] при попадании")
		});
		return ret;
	}}.getTooltip;
});
