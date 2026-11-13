::ReforgedLite.HooksMod.hook("scripts/skills/racial/ghost_racial", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Когда персонажа атакуют, он получает " + ::MSU.Text.colorPositive("+10") + " к защите в [ближнем|Concept.MeleeDefense] и [дальнем|Concept.RangeDefense] бою за каждую клетку между ним и нападающим.")
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
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не подвержен влиянию и не может получать [временные травмы|Concept.InjuryTemporary]")
			},
			{
				id = 22,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [кровотечению|Skill+bleeding_effect]")
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [отравлению|Skill+spider_poison_effect]")
			},
			{
				id = 24,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [отбрасыванию|Skill+knock_back] и захвату")
			},
			{
				id = 25,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к огню"
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
			},
			{
				id = 28,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [оглушению|Skill+stunned_effect]")
			},
			{
				id = 29,
				type = "text",
				icon = "ui/icons/morale.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не подвержен влиянию эффектов [боевого духа|Concept.Morale]")
			}
		]);
		return ret;
	}}.getTooltip;
});
