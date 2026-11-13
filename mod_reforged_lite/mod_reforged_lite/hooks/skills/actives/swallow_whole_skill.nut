::ReforgedLite.HooksMod.hook("scripts/skills/actives/swallow_whole_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Пожрать заживо стоящую рядом цель!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель попадает в живот персонажа, получая эффект [Проглочен целиком|Skill+swallowed_whole_effect]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("[Боевой дух|Concept.Morale] цели становится [сломленным|Concept.Morale]")
		});
		// ret.push({
		// 	id = 12,
		// 	type = "text",
		// 	icon = "ui/icons/special.png",
		// 	text = ::ReforgedLite.Mod.Tooltips.parseString("Цель теряет эффекты [Стена щитов|Skill+shieldwall_effect], [Стена копий|Skill+spearwall_effect] и [Контратака|Skill+riposte_effect]")
		// });
		return ret;
	}}.getTooltip;
});
