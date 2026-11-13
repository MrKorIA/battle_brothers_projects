::ReforgedLite.HooksMod.hook("scripts/skills/actives/charm_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Пытается очаровать персонажа, заставляя его повернуться против своих союзников и подчиниться вам. Чем выше [решимость|Concept.Bravery] персонажа, тем выше его шанс не поддаться очарованию.");
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Запускает у цели " + ::MSU.Text.colorNegative("2") + " [проверки боевого духа|Concept.Morale], при успехе обоих из них противник получает эффект [Очарован|Skill+charmed_effect]")
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
