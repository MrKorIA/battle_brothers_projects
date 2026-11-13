::ReforgedLite.HooksMod.hook("scripts/skills/actives/corpse_explosion_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Уничтожить труп или колыбель плоти с ужасающим взрывом. Взрыв наносит урон любой цели, стоящей на трупе, и всем рядом стоящим врагам, а также оставляет облако миазм на всех затронутых клетках.");
	}}.create;

	// Overwrite, because Vanilla uses a hard-coded implementation, instead of using getDefaultUtilityTooltip
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});

		return ret;
	}}.getTooltip;
});
