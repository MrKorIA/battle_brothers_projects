::ReforgedLite.HooksMod.hook("scripts/skills/racial/spider_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("[Решимость|Concept.Bravery] увеличивается на " + ::MSU.Text.colorPositive("+3") + " за каждого союзника того же вида на поле боя")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("При атаке [оплетённой паутиной|Skill+web_effect] цели урон, игнорирующий броню, увеличивается на " + ::MSU.Text.colorPositive("100%"))
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к эффекту [Ночное время|Skill+night_effect]")
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [отравлению|Skill+spider_poison_effect]")
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [обезоруживанию|Skill+disarmed_effect]")
			}
		]);
		return ret;
	}}.getTooltip;
});
