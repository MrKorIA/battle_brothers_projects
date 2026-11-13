::ReforgedLite.HooksMod.hook("scripts/skills/actives/possess_undead_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Сосредоточиться на одном из своих восставших, усиливая его!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Персонаж получает эффект [Власть над нежитью|Skill+possessing_undead_effect], а цель получает эффект [Одержим|Skill+possessed_undead_effect]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});
		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Нельзя использовать, потому что этот персонаж [вовлечён|Concept.ZoneOfControl] в ближний бой"))
			});
		}
		return ret;
	}}.getTooltip;
});
