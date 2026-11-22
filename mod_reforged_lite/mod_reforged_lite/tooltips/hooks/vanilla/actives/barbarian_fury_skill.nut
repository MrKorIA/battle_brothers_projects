::ReforgedLite.HooksMod.hook("scripts/skills/actives/barbarian_fury_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Icon = "skills/active_175.png";
		this.m.IconDisabled = "skills/active_175_sw.png";
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Позволяет поменяться местами с любым союзником, находящимся рядом, если только он не [оглушен|Skill+stunned_effect] или [обездвижен|Skill+rooted_effect]. Всегда держите свежих бойцов в переднем ряду!");
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		return this.skill.getDefaultUtilityTooltip();
	}}.getTooltip;
});
