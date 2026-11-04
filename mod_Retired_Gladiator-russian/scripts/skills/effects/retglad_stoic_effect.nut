this.retglad_stoic_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.retglad_stoic";
		this.m.Name = "Стоицизм";
		this.m.Icon = "ui/perks/perk_stoic_active.png";
		this.m.IconMini = "perk_30_mini"; //TO DO
		this.m.Overlay = "perk_30"; //TO DO
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Вас могут ранить, лишь если вы позволите это.";
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
				icon = "ui/icons/special.png",
				text = "Получает только [color=" + this.Const.UI.Color.PositiveValue + "]40%[/color] от любого урона"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Не подвержен травмам[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Длительность всех негативных эффектов снижена на 1 ход[/color]"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByInjuries = false;

		_properties.DamageReceivedTotalMult *= 0.6;

		_properties.NegativeStatusEffectDuration += -5;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

});

