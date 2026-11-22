// Вложенные ссылки в тактическом тултипе: ваниль выводит эффекты (id >= 100) плоским текстом.
// Превращаем имена в ссылки на месте (по совпадению имени с эффектом), не трогая чужие записи.
// Работает для скиллов ЛЮБЫХ модов: сопоставление идёт по живым эффектам актора.
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	q.getTooltip = @(__original) { function getTooltip( _targetedWithSkill = null )
	{
		local ret = __original(_targetedWithSkill);

		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying()) return ret;
		if (this.isDiscovered() == false) return ret;
		if (this.isHiddenToPlayer()) return ret;

		local extraData = "entityId:" + this.getID();
		local statusEffects = this.getSkills().query(::Const.SkillType.StatusEffect | ::Const.SkillType.TemporaryInjury, false, true);
		foreach (entry in ret)
		{
			if (entry.id < 100 || entry.type != "text") continue;
			foreach (statusEffect in statusEffects)
			{
				if (entry.text == statusEffect.getName())
				{
					entry.text = ::ReforgedLite.Mod.Tooltips.parseString(::ReforgedLite.NestedTooltips.getNestedSkillName(statusEffect, extraData, true));
					break;
				}
			}
		}

		return ret;
	}}.getTooltip;
});
