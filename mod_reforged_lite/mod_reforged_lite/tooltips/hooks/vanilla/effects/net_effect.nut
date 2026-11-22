::ReforgedLite.HooksMod.hook("scripts/skills/effects/net_effect", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 9,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::MSU.Text.colorNegative("Не может двигаться")
		});

		if (true)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(0.55) + " к [защите в ближнем бою|Concept.MeleeDefense]")
			});
		}

		if (true)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(0.55) + " к [защите в дальнем бою|Concept.RangeDefense]")
			});
		}

		if (true)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(0.55) + " к [инициативе|Concept.Initiative]")
			});
		}

		return ret;
	}}.getTooltip;
});
