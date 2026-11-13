::ReforgedLite.HooksMod.hook("scripts/skills/actives/kraken_ensnare_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Обвивает цель огромным щупальцем, дабы неспешно подтащить к ненасытной пасти!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Цель получает эффект [Оплетён|Skill+kraken_ensnare_effect]")
		});
		return ret;
	}}.getTooltip;
});
