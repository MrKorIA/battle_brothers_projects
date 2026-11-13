::ReforgedLite.HooksMod.hook("scripts/skills/actives/alp_teleport_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Description = "Телепортируется на случайную клетку при попадании по любому альпу."; // Vanilla is missing a description for this skill
		// Vanilla is missing icons for this skill
		this.m.Icon = "skills/rf_alp_teleport_skill.png";
		this.m.IconDisabled = "skills/rf_alp_teleport_skill_sw.png";
	}}.create;
});
