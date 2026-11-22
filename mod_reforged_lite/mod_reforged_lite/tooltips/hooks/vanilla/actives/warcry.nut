::ReforgedLite.HooksMod.hook("scripts/skills/actives/warcry", function(q) {
	q.create = @(__original) { function create()
	{
		__original();

		// VanillaFix: vanilla uses the wrong icon active_41
		this.m.Icon = "skills/active_49.png";
		this.m.IconDisabled = "skills/active_49_sw.png";

		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Персонаж издаст оглушительный рёв, поднимающий [боевой дух|Concept.Morale] союзников и приводящий в [смятение|Concept.Morale] врагов!");
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Все союзники и враги получают положительные и отрицательные [проверки боевого духа|Concept.Morale] соответственно, причём чем ближе персонаж, тем сильнее проверка")
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Все союзники на поле боя восстанавливают " + ::MSU.Text.colorPositive(20) + " [выносливости|Concept.Fatigue]")
		});

		return ret;
	}}.getTooltip;
});
