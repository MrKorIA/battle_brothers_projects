::ReforgedLite.HooksMod.hook("scripts/skills/actives/teleport_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Путешествуя между измерениями, персонаж возникает в другом месте сего мира.";
	}}.create;

	// Vanilla getTooltip for this skill doesn't mention the terrain transformation
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Преобразует местность вокруг начальной и конечной клеток телепортации в заснеженную.")
		});
		return ret;
	}}.getTooltip;
});
