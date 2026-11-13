::ReforgedLite.HooksMod.hook("scripts/skills/actives/goblin_whip", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Хлестнуть кнутом, дабы придать гоблинам рвения в битве.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Повышает [боевой дух|Concept.Morale] обычных целей до 'уверенного', а у бегущих с поля боя союзников - до 'уравновешенного'.")
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
