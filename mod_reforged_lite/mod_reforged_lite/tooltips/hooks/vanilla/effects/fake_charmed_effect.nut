::ReforgedLite.HooksMod.hook("scripts/skills/effects/fake_charmed_effect", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// We change the name from vanilla "Очарован" to differentiate it from the real "Очарован" effect that players get
		this.m.Name = "Зачарованный";
		// Vanilla is missing a description for this skill
		this.m.Description = "Этот персонаж очарован и более не управляет своими действиями. Ныне он - лишь кукла, у которой нет иного выбора, кроме как подчиниться своему хозяину";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+20") + " к [решимости|Concept.Bravery]")
		});
		return ret;
	}}.getTooltip;
});
