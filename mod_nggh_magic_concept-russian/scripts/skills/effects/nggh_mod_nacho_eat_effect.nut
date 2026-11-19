this.nggh_mod_nacho_eat_effect <- ::inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.nacho_eat";
		this.m.Name = "Подкрепился";
		this.m.Icon = "ui/perks/perk_energize_meal.png";
		this.m.IconMini = "perk_energize_meal_mini";
		this.m.Overlay = "perk_energize_meal";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Объедение! Съеденная пища придала этому персонажу сил на [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.TurnsLeft + "[/color] хода(ов). Эффект можно увеличить.";
	}

	function onAdded()
	{
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] к наносимому урону"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] к восстановлению выносливости за ход"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+10[/color] к решимости"
			},
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.FatigueRecoveryRate += 5;
		_properties.DamageTotalMult *= 1.25;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

