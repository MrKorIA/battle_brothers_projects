::ReforgedLite.HooksMod.hook("scripts/skills/effects/possessing_undead_effect", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Этот персонаж таинственным образом получил прямой контроль над восставшим мертвецом.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (!::MSU.isNull(this.m.Possessed) && this.m.Possessed.isAlive())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = ::ReforgedLite.Mod.Tooltips.parseString(::ReforgedLite.NestedTooltips.getNestedEntityImage(this.m.Possessed)),
				text = "Повелевает мертвецом " + ::ReforgedLite.Mod.Tooltips.parseString(::ReforgedLite.NestedTooltips.getNestedEntityName(this.m.Possessed)),
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Эффект будет потерян при получении персонажем урона по [ОЗ|Concept.Hitpoints] в количестве " + ::MSU.Text.colorDamage(::Const.Combat.InjuryMinDamage) + ", или если находящийся под его властью мертвец погибнет")
		});

		return ret;
	}}.getTooltip;
});
