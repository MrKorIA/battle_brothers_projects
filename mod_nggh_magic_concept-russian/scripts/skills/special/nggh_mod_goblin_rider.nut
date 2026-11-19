this.nggh_mod_goblin_rider <- ::inherit("scripts/skills/nggh_mod_rider_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_rider_skill.create();
		this.m.ID = "special.goblin_rider";
		this.m.Name = "Оседлать";
		this.m.Description = "Обладают большой мобильностью и тактическими преимуществами, но при верховой езде сложнее использовать большинство видов оружия дальнего боя. Получают атаку укусом, которую можно использовать бесплатно раз в ход.";
		this.m.Icon = "ui/perks/impulse_perk.png";
		this.m.IconMini = "impulse_perk_mini";
	}

	function getDescription()
	{
		if (this.getManager() == null)
		{
			return this.m.Description;
		}
		
		return "Вы едете верхом на [color=#1e468f]" + this.getManager().getMount().getName() + "[/color]! В этом есть свои преимущества, например, подвижность. А в довершение всего, это ещё одна жизнь, о которой вы должны заботиться.";
	}

});

