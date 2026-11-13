::ReforgedLite.HooksMod.hook("scripts/skills/racial/champion_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = ::MSU.Text.colorPositive("15%") + " к наносимому урону"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("15%") + " к [навыку ближнего боя|Concept.MeleeSkill]")
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("15%") + " к [навыку дальнего боя|Concept.RangeSkill]")
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive(::Math.floor((this.getDefenseMultiplier() - 1.0) * 100) + "%") + " к [защите в ближнем бою|Concept.MeleeDefense]")
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive(::Math.floor((this.getDefenseMultiplier() - 1.0) * 100) + "%") + " к [защите в дальнем бою|Concept.RangeDefense]")
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/health.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive(::Math.floor((this.getHitpointMult() - 1.0) * 100) + "%") + " к максимуму [ОЗ|Concept.Hitpoints]")
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("50%") + " к [максимальной выносливости|Concept.MaximumFatigue]")
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("50%") + " к [решимости|Concept.Bravery]")
			},
			{
				id = 18,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("15%") + " к [инициативе|Concept.Initiative]")
			}
		]);
		return ret;
	}}.getTooltip;

	// Хелперы отражают ванильные условия champion_racial (нужны только тултипу)
	q.getDefenseMultiplier <- { function getDefenseMultiplier()
	{
		local defenseMult = 1.25;
		local b = this.getContainer().getActor().getBaseProperties();
		if (b.MeleeDefense >= 20 || b.RangedDefense >= 20 || b.MeleeDefense >= 15 && b.RangedDefense >= 15) defenseMult *= 1.25;
		return defenseMult;
	}}.getDefenseMultiplier;

	q.getHitpointMult <- { function getHitpointMult()
	{
		local hitpointMult = 1.35;
		local b = this.getContainer().getActor().getBaseProperties();
		if (b.MeleeDefense >= 20 || b.RangedDefense >= 20 || b.MeleeDefense >= 15 && b.RangedDefense >= 15) return hitpointMult;
		return (hitpointMult * 1.35);
	}}.getHitpointMult;
});
