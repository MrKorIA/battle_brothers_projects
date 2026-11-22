::ReforgedLite.HooksMod.hook("scripts/skills/effects/berserker_rage_effect", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Description = "Этот персонаж растворился в ярости берсерка."
	}}.create;

	q.getDescription = @(__original) { function getDescription()	// Vanilla overwrote this returning "TODO" so we need to fix that
	{
		return this.skill.getDescription();
	}}.getDescription;

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Весь получаемый урон уменьшается на " + ::MSU.Text.colorNegative((100.0 - (this.calcDamageTakenMult() * 100.0)) + "%")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = ::MSU.Text.colorPositive("+" + this.m.RageStacks) + " к урону"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + this.m.RageStacks) + " к [решимости|Concept.Bravery]")
			}
		]);
		return ret;
	}}.getTooltip;

	// Хелпер повторяет ванильный расчёт (только для тултипа)
	q.calcDamageTakenMult <- { function calcDamageTakenMult()
	{
		return ::Math.maxf(0.3, 1.0 - 0.02 * this.m.RageStacks);
	}}.calcDamageTakenMult;
});
