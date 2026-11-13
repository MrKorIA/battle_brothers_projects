::ReforgedLite.HooksMod.hook("scripts/skills/actives/sling_stone_skill", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getRangedTooltip(this.skill.getDefaultTooltip());

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Имеет " + ::MSU.Text.colorNegative("100%") + " шанс [выбить дух|Skill+dazed_effect] при попадании в голову цели")
		});

		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Нельзя использовать, потому что этот персонаж [вовлечён|Concept.ZoneOfControl] в ближний бой"))
			});
		}

		return ret;
	}}.getTooltip;
});
