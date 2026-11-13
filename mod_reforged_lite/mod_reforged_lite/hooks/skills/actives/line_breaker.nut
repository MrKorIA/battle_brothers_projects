::ReforgedLite.HooksMod.hook("scripts/skills/actives/line_breaker", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Персонаж будет двигаться вперёд, ломая ряды и отбрасывая врага.";
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Персонаж отталкивает цель и встаёт на её место"
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Наносит дополнительно " + ::MSU.Text.colorNegative("10") + " урона по [выносливости|Concept.Fatigue]")
		});

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Нельзя использовать, пока персонаж [обездвижен|Concept.Rooted]"))
			});
		}

		return ret;
	}}.getTooltip;
});
