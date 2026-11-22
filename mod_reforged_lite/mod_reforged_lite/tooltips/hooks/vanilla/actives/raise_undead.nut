::ReforgedLite.HooksMod.hook("scripts/skills/actives/raise_undead", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Оживляет труп, дабы он выполнял ваши приказы!";
		this.m.IconDisabled = "skills/active_26_sw.png";	// Vanilla uses a wrong icon here
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Поднимает выбранный труп в виде восставшего")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});
		return ret;
	}}.getTooltip;
});
