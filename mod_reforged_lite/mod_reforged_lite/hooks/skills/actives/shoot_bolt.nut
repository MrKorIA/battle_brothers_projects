::ReforgedLite.HooksMod.hook("scripts/skills/actives/shoot_bolt", function(q) {
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
				text = "Осталось болтов: " + ::MSU.Text.colorPositive(ammo) + ""
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("Необходим колчан, заполненный болтами")
			});
		}

		if (!this.getItem().isLoaded())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("Требуется перезарядка")
			});
		}

		return ret;
	}}.getTooltip;
});
