::ReforgedLite.HooksMod.hook("scripts/skills/actives/throw_spear_skill", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();

		local damage = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).getShieldDamage();
		if (damage != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/shield_damage.png",
				text = "Наносит " + ::MSU.Text.colorDamage(damage) + " урона щитам"
			});
		}

		ret.extend(this.getRangedTooltip());

		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Нельзя использовать, потому что этот персонаж [вовлечён|Concept.ZoneOfControl] в ближний бой"))
			});
		}

		return ret;
	}}.getTooltip;
});
