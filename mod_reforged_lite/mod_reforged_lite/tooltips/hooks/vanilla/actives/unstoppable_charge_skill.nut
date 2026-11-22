::ReforgedLite.HooksMod.hook("scripts/skills/actives/unstoppable_charge_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Ворвитесь в клетку с неостановимой силой, сея хаос в округе!";
	}}.create;

	// Vanilla has a getTooltip function defined for this skill but it doesn't provide all the details
	// so we overwrite it to produce a better tooltip overall
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Персонаж переместится на целевую клетку и случайным образом [оглушит|Skill+stunned_effect] или [ошеломит|Skill+staggered_effect] и [отбросит|Skill+knock_back] врагов на этой клетке")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Отброшенные назад цели теряют эффекты [Стена щитов|Skill+shieldwall_effect], [Стена копий|Skill+spearwall_effect] и [Контратака|Skill+riposte_effect]")
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
