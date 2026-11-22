::ReforgedLite.HooksMod.hook("scripts/skills/racial/lindwurm_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("При получении удара от стоящего рядом противника, наносящего не менее " + ::MSU.Text.colorPositive("11") + " урона [ОЗ|Concept.Hitpoints], к врагу применяется эфффект [Кислота линдвурма|Skill+lindwurm_acid_effect]")
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к эффекту [Ночное время|Skill+night_effect]")
			},
			{
				id = 24,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [отбрасыванию|Skill+knock_back] и захвату")
			},
			{
				id = 26,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [обезоруживанию|Skill+disarmed_effect]")
			},
			{
				id = 27,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [обездвиживанию|Concept.Rooted]")
			}
			{
				id = 28,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [оглушению|Skill+stunned_effect]")
			}
		]);
		return ret;
	}}.getTooltip;
});
