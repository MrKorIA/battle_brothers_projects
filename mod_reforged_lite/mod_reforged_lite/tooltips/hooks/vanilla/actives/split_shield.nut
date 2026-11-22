::ReforgedLite.HooksMod.hook("scripts/skills/actives/split_shield", function(q) {
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/shield_damage.png",
			text = "Наносит " + ::MSU.Text.colorDamage(this.getContainer().getActor().getMainhandItem().getShieldDamage()) + " урона щитам"
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Наносит " + ::MSU.Text.colorDamage(this.RF_getFatigueDamage()) + " урона по [выносливости|Concept.Fatigue] цели")
		});

		if (this.getMaxRange() > 1)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в " + ::MSU.Text.colorPositive(this.m.MaxRange) + " клетки"
			});
		}

		return ret;
	}}.getTooltip;

	q.create = @(__original) { function create()
	{
		__original();
		this.m.Name = "Разбить щит";
		this.m.Description = "Атака, направленная на щит противника. Может быть использована только против целей с щитом. Всегда попадает в щит и наносит ему урон, одновременно утомляя цель.";
	}}.create;

	// Хелпер расчёта урона по выносливости (нужен getTooltip'у; в Reforged также используется onUse, который не переносим)
	q.RF_getFatigueDamage <- { function RF_getFatigueDamage()
	{
		return ::MSU.isNull(this.getItem()) ? this.getContainer().getActor().getMainhandItem().getShieldDamage() : this.getItem().getShieldDamage();
	}}.RF_getFatigueDamage;
});
