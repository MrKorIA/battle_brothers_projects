::ReforgedLite.HooksMod.hook("scripts/skills/actives/uproot_zoc_skill", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Цель становится [ошеломленной|Skill+staggered_effect] и [обездвиженной|Skill+rooted_effect] при попадании")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не повреждает и не влияет на других леших")
			}
		]);
		return ret;
	}}.getTooltip;
});
