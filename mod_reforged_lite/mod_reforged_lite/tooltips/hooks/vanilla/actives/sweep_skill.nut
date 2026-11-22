::ReforgedLite.HooksMod.hook("scripts/skills/actives/sweep_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Взмахивает кулаком по широкой дуге, поражая до трёх стоящих рядом персонажей против часовой стрелки!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Может поразить до " + ::MSU.Text.colorPositive(3) + " целей")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Отбрасывает назад цели, не имеющие невосприимчивости к [отбрасыванию|Skill+knock_back] или [обездвиживанию|Skill+rooted_effect]. Если цель отброшена назад, то она теряет эффекты [Стена щитов|Skill+shieldwall_effect], [Стена копий|Skill+spearwall_effect] и [Контратака|Skill+riposte_effect]")
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цели, невосприимчивые к [отбрасыванию|Skill+knock_back] или [обездвиживанию|Skill+rooted_effect], вместо этого получают эффект [Ошеломлён|Skill+staggered_effect]")
		});
		return ret;
	}}.getTooltip;
});
