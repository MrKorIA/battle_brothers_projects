::ReforgedLite.HooksMod.hook("scripts/skills/actives/merge_golem_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Вырасти, объединив оживший песок и камни вокруг себя!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Полностью восстанавливает [ОЗ|Concept.Hitpoints]")
		});

		local entityType = ::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()) ? ::Const.EntityType.SandGolem : this.getContainer().getActor().getType();
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Поглощает двух стоящих рядом " + ::Const.Strings.EntityNamePlural[entityType] + ", [вырастая|Skill+golem_racial]")
		});
		return ret;
	}}.getTooltip;
});
