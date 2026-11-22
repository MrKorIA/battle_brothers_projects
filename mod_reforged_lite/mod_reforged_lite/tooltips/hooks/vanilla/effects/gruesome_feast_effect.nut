::ReforgedLite.HooksMod.hook("scripts/skills/effects/gruesome_feast_effect", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Пожирая трупы, этот монстр становится больше и мощнее.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local size = this.getContainer().getActor().getSize();
		if (size == 2)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+120") + " к [ОЗ|Concept.Hitpoints]")
			});
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + " к [навыку ближнего боя|Concept.MeleeSkill]")
			});
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+5") + " к [защите в ближнем бою|Concept.MeleeDefense]")
			});
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-5") + " к [защите в дальнем бою|Concept.RangeDefense]")
			});
			ret.push({
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+30") + " к [решимости|Concept.Bravery]")
			});
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+15") + " к минимальному урону")
			});
			ret.push({
				id = 16,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+20") + " к максимальному урону")
			});
			ret.push({
				id = 17,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-15") + " к [инициативе|Concept.Initiative]")
			});
		}
		else if (size == 3)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+300") + " к [ОЗ|Concept.Hitpoints]")
			});
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+20") + " к [навыку ближнего боя|Concept.MeleeSkill]")
			});
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + " к [защите в ближнем бою|Concept.MeleeDefense]")
			});
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-10") + " к [защите в дальнем бою|Concept.RangeDefense]")
			});
			ret.push({
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+60") + " к [решимости|Concept.Bravery]")
			});
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+30") + " к минимальному урону")
			});
			ret.push({
				id = 16,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+40") + " к максимальному урону")
			});
			ret.push({
				id = 17,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-30") + " к [инициативе|Concept.Initiative]")
			});
		}

		return ret;
	}}.getTooltip;
});
