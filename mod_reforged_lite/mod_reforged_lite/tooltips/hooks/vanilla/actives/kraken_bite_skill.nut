::ReforgedLite.HooksMod.hook("scripts/skills/actives/kraken_bite_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Терзает врага в огромной пасти!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Накладывает на цель эффект [Кровотечение|Skill+bleeding_effect], если нанесено " + ::MSU.Text.colorNegative(::Const.Combat.MinDamageToApplyBleeding) + " и более урона по [ОЗ|Concept.Hitpoints]")
		});
		return ret;
	}}.getTooltip;
});
