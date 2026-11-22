::ReforgedLite.HooksMod.hook("scripts/skills/actives/throw_balls", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getRangedTooltip(this.skill.getDefaultTooltip());

		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Осталось шипастых шаров: " + ::MSU.Text.colorPositive(ammo) + " "
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("Шипастые шары закончились")
			});
		}

		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Нельзя использовать, потому что этот персонаж [вовлечён|Concept.ZoneOfControl] в ближний бой"))
			});
		}

		return ret;
	}}.getTooltip;
});
