// Мини-реализация affordability preview (аналог preview-системы framework):
// при наведении на навык в тактике (costs preview из turn_sequence_bar) запоминаем
// объект скилла, чтобы травмы/эффекты могли учитывать превью в onUpdate.
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	q.m.RFL_PreviewSkill <- null;

	q.setPreviewSkillID = @(__original) { function setPreviewSkillID( _id )
	{
		__original(_id);
		if (_id == "")
		{
			this.m.RFL_PreviewSkill = null;
		}
		else
		{
			local skill = this.getSkills().getSkillByID(_id);
			this.m.RFL_PreviewSkill = skill == null ? null : this.WeakTableRef(skill);
		}
	}}.setPreviewSkillID;

	q.isPreviewing <- { function isPreviewing()
	{
		return this.m.RFL_PreviewSkill != null && this.m.RFL_PreviewSkill.get() != null;
	}}.isPreviewing;

	q.getPreviewSkill <- { function getPreviewSkill()
	{
		return this.m.RFL_PreviewSkill == null ? null : this.m.RFL_PreviewSkill.get();
	}}.getPreviewSkill;

	// Вложенные ссылки в тактическом тултипе: ваниль выводит эффекты (id >= 100) плоским текстом.
	// Превращаем имена в ссылки на месте (по совпадению имени с эффектом), не трогая чужие записи.
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
