::ReforgedLite.HooksMod.hook("scripts/skills/effects/hex_master_effect", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Этот персонаж проклял жертву, дабы она испытала всю боль, причинённую ему, - сильный оберег фактор против враждебных намерений.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (!::MSU.isNull(this.m.Slave) && !::MSU.isNull(this.m.Slave.getContainer()))
		{
			local victim = this.m.Slave.getContainer().getActor();
			if (this.m.Slave.isAlive())
			{
				ret.push({
					id = 10,
					type = "text",
					icon = ::ReforgedLite.Mod.Tooltips.parseString(::ReforgedLite.NestedTooltips.getNestedEntityImage(victim)),
					text = "Жертва: " + ::ReforgedLite.Mod.Tooltips.parseString(::ReforgedLite.NestedTooltips.getNestedEntityName(victim)),
				});
			}
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Весь входящий урон по [ОЗ|Concept.Hitpoints] в полном объеме наносится и жертве.")
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Истекает через " + ::MSU.Text.colorNegative(this.m.TurnsLeft) + " [ход(а,ов)|Concept.Turn]")
		});

		return ret;
	}}.getTooltip;
});
