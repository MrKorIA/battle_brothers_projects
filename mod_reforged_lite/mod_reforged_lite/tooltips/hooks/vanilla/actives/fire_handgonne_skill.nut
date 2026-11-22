::ReforgedLite.HooksMod.hook("scripts/skills/actives/fire_handgonne_skill", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может задеть до 6 целей"
		});

		local rangedTooltip = this.getRangedTooltip();
		rangedTooltip[rangedTooltip.len() - 1].text += ". На этот шанс не влияют предметы или персонажи на линии огня."

		ret.extend(rangedTooltip);

		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Осталось выстрелов: " + ::MSU.Text.colorPositive(ammo) + ""
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("Необходима сумка с порохом")
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
