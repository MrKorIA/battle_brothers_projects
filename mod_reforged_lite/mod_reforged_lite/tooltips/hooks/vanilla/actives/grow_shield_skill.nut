::ReforgedLite.HooksMod.hook("scripts/skills/actives/grow_shield_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Восстановить щит, дабы защитить уязвимые места!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Даёт [щит лешего|Item+schrat_shield].")
		});
		return ret;
	}}.getTooltip;
});
