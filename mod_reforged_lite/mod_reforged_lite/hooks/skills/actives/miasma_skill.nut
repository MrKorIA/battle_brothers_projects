::ReforgedLite.HooksMod.hook("scripts/skills/actives/miasma_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Призывает ядовитые миазмы, наносящие урон всему живому и дышащему!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("На указанных клетках появляются миазмы, эффект длится " + ::MSU.Text.colorPositive(3) + " [хода боя|Concept.Round]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Все персонажи, кроме нежити, получают " + ::MSU.Text.colorNegative(5) + " - " + ::MSU.Text.colorNegative(10) + " урона, когда заканчивают свой [ход|Concept.Turn] в облаке миазм")
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Убирает существующие эффекты клетки, такие как огонь или дым")
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});
		return ret;
	}}.getTooltip;
});
