::ReforgedLite.HooksMod.hook("scripts/skills/actives/serpent_hook_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Обхватывает цель хвостом и притягивает её в более уязвимое положение!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Захватывает цель и перетаскивает её ближе к персонажу")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель получает эффект [Ошеломлён|Skill+staggered_effect]")
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель теряет эффекты [Стена щитов|Skill+shieldwall_effect], [Стена копий|Skill+spearwall_effect] и [Контратака|Skill+riposte_effect]")
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель получает урон при притягивании с высоты")
		});
		ret.push({
			id = 14,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});
		return ret;
	}}.getTooltip;
});
