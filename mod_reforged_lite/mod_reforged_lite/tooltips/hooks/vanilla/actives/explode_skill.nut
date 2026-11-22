::ReforgedLite.HooksMod.hook("scripts/skills/actives/explode_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Взрывается осколками костей, наносящими урон всем окружающим.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Наносит небольшое количество урона всем персонажам на соседних клетках")
		});
		return ret;
	}}.getTooltip;
});
