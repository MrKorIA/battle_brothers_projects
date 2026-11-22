::ReforgedLite.HooksMod.hook("scripts/skills/actives/horrific_scream", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Издать вопль, заставляющий врагов бежать в ужасе!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель проходит " + ::MSU.Text.colorNegative(4) + " ментальные [проверки боевого духа|Concept.Morale]")
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});

		return ret;
	}}.getTooltip;
});
