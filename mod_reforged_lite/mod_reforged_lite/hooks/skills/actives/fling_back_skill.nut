::ReforgedLite.HooksMod.hook("scripts/skills/actives/fling_back_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Отбросьте персонажа назад и переместитесь на его место!";
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель получает " + ::MSU.Text.colorNegative("10") + " [усталости|Concept.Fatigue]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель отбрасывается назад и получает урон при приземлении")
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель теряет эффекты [Стена щитов|Skill+shieldwall_effect], [Стена копий|Skill+spearwall_effect] и [Контратака|Skill+riposte_effect].")
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Вы перемещаетесь на целевую клетку, игнорируя [зоны контроля|Concept.ZoneOfControl]")
		});
		return ret;
	}}.getTooltip;
});
