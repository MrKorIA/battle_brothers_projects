this.mgl_khan_helmet_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.mgl_khan_helmet";
		this.m.Name = "Взгляд Хана";
		this.m.Description = "Через прорези этого шлема мир видится яснее и смелее, словно сам владыка смотрит сквозь них вместе с вами. Рядом с его доспехом сила наследия полна.";
		this.m.Icon = "ui/perks/perk_28.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = false;
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
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к инициативе"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к решимости"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Вместе с доспехом Хана: страж доспеха может явиться дважды за бой"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += 10;
		_properties.Bravery += 10;
	}
});
