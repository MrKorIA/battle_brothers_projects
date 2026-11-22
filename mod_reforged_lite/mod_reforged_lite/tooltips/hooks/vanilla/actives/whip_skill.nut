::ReforgedLite.HooksMod.hook("scripts/skills/actives/whip_skill", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		foreach (entry in ret)
		{
			// Replace vanilla tooltip about bleeding to conform to Reforged bleeding mechanic
			if (entry.id == 8)
			{
				entry.text = ::ReforgedLite.Mod.Tooltips.parseString("Накладывает на цель эффект [Кровотечение|Skill+bleeding_effect], если нанесено " + ::MSU.Text.colorDamage(::Const.Combat.MinDamageToApplyBleeding) + " и более урона по [ОЗ|Concept.Hitpoints]")
				break;
			}
		}
		return ret;
	}}.getTooltip;
});
