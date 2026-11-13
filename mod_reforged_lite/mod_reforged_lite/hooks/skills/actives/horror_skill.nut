::ReforgedLite.HooksMod.hook("scripts/skills/actives/horror_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Вызовите самые глубокие страхи ваших целей, заставив их замереть от ужаса!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель проходит ментальную [проверку на уменьшение боевого духа|Concept.Morale] со штрафом " + ::MSU.Text.colorNegative(-15) + " к [решимости|Concept.Bravery]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель проходит дополнительную ментальную [проверку боевого духа|Concept.Morale] со штрафом " + ::MSU.Text.colorNegative(-5) + " к [решимости|Concept.Bravery]. Если эта [проверка боевого духа|Concept.MoraleCheck] провалена, то цель получает эффект [Охвачен ужасом|Skill+horrified_effect]")
		});
		return ret;
	}}.getTooltip;
});
