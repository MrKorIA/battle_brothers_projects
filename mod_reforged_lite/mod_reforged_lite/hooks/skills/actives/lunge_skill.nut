::ReforgedLite.HooksMod.hook("scripts/skills/actives/lunge_skill", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Перемещает персонажа ближе к цели, игнорируя вражеские [зоны контроля|Concept.ZoneOfControl].")
			},
			{
				id = 7, // vanilla has id 6 for this, the same as previous entry
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Наносит дополнительный урон пропорционально текущей [инициативе|Concept.Initiative] персонажа")
			}
		]);


		if (this.getMaxRange() > 2)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Требует свободного пути и не может менять уровень высоты более одного раза по пути"
			});
		}

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("Нельзя использовать, пока персонаж [обездвижен|Concept.Rooted]")
			});
		}

		return ret;
	}}.getTooltip;
});
