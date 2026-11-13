::ReforgedLite.HooksMod.hook("scripts/skills/actives/fire_mortar_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Выстреливает снаряд высоко в небеса, дабы затем сокрушить твердь мощным взрывом.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Помечает целевую клетку и окружающие её клетки местом удара, который произойдёт на следующий [ход|Concept.Turn] этого персонажа. При ударе персонажи, находящиеся на клетках, получают урон и могут быть [контужены|Skill+shellshocked_effect]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Можно использовать только раз в " + ::MSU.Text.colorNegative(this.m.Cooldown) + " [хода|Concept.Turn]")
		});
		return ret;
	}}.getTooltip;
});
