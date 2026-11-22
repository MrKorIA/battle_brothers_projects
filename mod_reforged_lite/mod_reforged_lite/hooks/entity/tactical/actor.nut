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
});
