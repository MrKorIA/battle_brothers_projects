::ReforgedLite.HooksMod.hook("scripts/skills/actives/throw_golem_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Бросить в цель глыбу из своего песка и камня, разделив себя на более мелкие живые части!";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		local entityType = ::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()) ? ::Const.EntityType.SandGolem : this.getContainer().getActor().getType();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = format("%s%s порождается рядом с целью", ::Const.Strings.getArticle(::Const.Strings.EntityName[entityType]), ::Const.Strings.EntityName[entityType])
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Уменьшает размер персонажа и порождает двух " + ::Const.Strings.EntityNamePlural[entityType] + " этого же размера рядом с ним")
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
			}
		]);
		return ret;
	}}.getTooltip;
});
