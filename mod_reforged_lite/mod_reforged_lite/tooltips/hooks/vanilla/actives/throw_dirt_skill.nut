::ReforgedLite.HooksMod.hook("scripts/skills/actives/throw_dirt_skill", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		local distractedEffect = ::new("scripts/skills/effects/distracted_effect");
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Накладывает на цель эффект [Отвлечён|Skill+distracted_effect]"),
			children = distractedEffect.getTooltip().slice(2) // slice 2 to remove name and description
		});

		return ret;
	}}.getTooltip;
});
