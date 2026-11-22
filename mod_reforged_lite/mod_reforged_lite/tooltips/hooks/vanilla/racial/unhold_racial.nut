::ReforgedLite.HooksMod.hook("scripts/skills/racial/unhold_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/health.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("В начале каждого [хода|Concept.Turn] этот персонаж восстанавливает " + ::MSU.Text.colorPositive("15%") + " от максимального количества [ОЗ|Concept.Hitpoints]")
		});

		// This is about the vanila behavior coded in this skill's `onUpdate` function.
		// We show it here in the absence of a better UI that shows turn order initiative in addition to regular initiative.
		local actor = this.getContainer().getActor();
		if (::MSU.isKindOf(actor, "unhold_armored") || ::MSU.isKindOf(actor, "unhold_frost_armored") || ::MSU.isEqual(actor, ::MSU.getDummyPlayer()))
		{
			local roundsForInitiativeBonus = ::Tactical.isActive() ? (::Tactical.State.isScenarioMode() ? 3 : 2) : "few";
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Очередность [хода|Concept.Turn] определяется с учётом прибавки " + ::MSU.Text.colorPositive("+40") + " к [инициативе|Concept.Initiative] в течение первых " + roundsForInitiativeBonus + " [ходов|Concept.Round]")
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [обезоруживанию|Skill+disarmed_effect]")
		})
		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к умению [Рокировка|Skill+rotation]")
		});

		return ret;
	}}.getTooltip;
});
