::ReforgedLite.HooksMod.hook("scripts/skills/actives/darkflight", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Превращается в рой летучих мышей, способный быстро перемещаться по полю боя, игнорируя [зоны контроля|Concept.ZoneOfControl].");
	}}.create;

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " клетки"
		});

		return ret;
	}}.getTooltip;
});
