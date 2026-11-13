::ReforgedLite.HooksMod.hook("scripts/skills/actives/charge", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Броситься вперёд, чтобы врезаться в своих врагов с огромной силой!";
	}}.create;

	// Vanilla has a getTooltip function defined for this skill but it doesn't provide all the details
	// so we overwrite it to produce a better tooltip overall
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Перемещается на целевую клетку")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Имеет " + ::MSU.Text.colorPositive("100%") + " шанс оглушить случайного рядом стоящего противника при его наличии. Этот шанс уменьшается защитой от щита цели и от умения [Стена щитов|Skill+shieldwall_effect].")
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
			}
		]);

		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Нельзя использовать, потому что этот персонаж [вовлечён|Concept.ZoneOfControl] в ближний бой")
			});
		}

		return ret;
	}}.getTooltip;
});
