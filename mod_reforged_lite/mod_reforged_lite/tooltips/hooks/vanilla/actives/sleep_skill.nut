::ReforgedLite.HooksMod.hook("scripts/skills/actives/sleep_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Усыпляет врагов, делая их уязвимыми для пожирающих душу кошмаров!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель получает ментальную [проверку боевого духа|Concept.Morale] с тем большим штрафом к [решимости|Concept.Bravery], чем ближе она к персонажу. Если проверка успешна, то цель [засыпает|Skill+sleeping_effect]")
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
