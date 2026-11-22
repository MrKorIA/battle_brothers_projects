::ReforgedLite.HooksMod.hook("scripts/skills/effects/possessed_undead_effect", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Этот персонаж одержим до конца своего [хода|Concept.Turn].")
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Количество [ОД|Concept.ActionPoints] увеличено до " + ::MSU.Text.colorPositive("12"))
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+15") + " к [навыку ближнего боя|Concept.MeleeSkill]")
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + " к [защите в ближнем бою|Concept.MeleeDefense]")
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + " к [защите в дальнем бою|Concept.RangeDefense]")
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+50") + " к [инициативе|Concept.Initiative]")
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Весь получаемый урон уменьшается на " + ::MSU.Text.colorNegative("25%")
			}
		]);
		return ret;
	}}.getTooltip;
});
