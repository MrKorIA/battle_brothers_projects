::ReforgedLite.HooksMod.hook("scripts/skills/actives/nightmare_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Погрузи свою цель в мир кошмаров - и сожри её душу, пока она спит!";
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Может быть использован только на [спящие|Skill+sleeping_effect] цели")
		});
		return ret;
	}}.getTooltip;
});
