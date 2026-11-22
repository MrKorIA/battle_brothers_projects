::ReforgedLite.HooksMod.hook("scripts/skills/actives/web_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		// Vanilla is missing a description for this skill
		this.m.Description = "Заплетает паутину вокруг цели, приковывая её к земле и лишая возможности сражаться и защищаться.";
	}}.create;

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Цель получит эффект [$ $|Skill+web_effect]")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Можно использовать только раз в " + ::MSU.Text.colorNegative(3) + " [хода|Concept.Turn]")
			}
		]);
		return ret;
	}}.getTooltip;
});
