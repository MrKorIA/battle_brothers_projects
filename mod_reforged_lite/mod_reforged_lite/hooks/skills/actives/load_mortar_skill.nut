::ReforgedLite.HooksMod.hook("scripts/skills/actives/load_mortar_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Загрузить огромный заряд в стоящую рядом мортиру.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Можно использовать только раз в " + ::MSU.Text.colorNegative(this.m.Cooldown) + " [хода|Concept.Turn]")
		});
		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Нельзя использовать, потому что этот персонаж [вовлечён|Concept.ZoneOfControl] в ближний бой"))
			});
		}
		return ret;
	}}.getTooltip;
});
