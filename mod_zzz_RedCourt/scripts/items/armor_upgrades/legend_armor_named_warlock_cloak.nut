this.legend_armor_named_warlock_cloak <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.legend_named_warlock_cloak";
		this.m.Name = "Плащ чернокнижника";
		this.m.Description = "Плащ из кожи мертвецов и тёмной магии.";
		this.m.ArmorDescription = "К этой броне прикреплён плащ из кожи мертвецов и тёмной магии. Благодаря чему добавляет носителю живучести и уверенности в своих силах.";
		this.m.Icon = "legend_armor/upgrade_cursed_cloak.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "legend_armor/icon_cursed_cloak_01.png";
		this.m.OverlayIconLarge = "legend_armor/inventory_cursed_cloak_01.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "bust_cursed_cloak_01";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "bust_cursed_cloak_01_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "bust_cursed_cloak_01_dead";
		this.m.ConditionModifier = 20;
		this.m.Value = 2000;
		this.m.StaminaModifier = 2;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к навыку ближнего боя при уверенном боевом духе."
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к защите ближнего боя при уверенном боевом духе."
		});
		result.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к защите дальнего боя при уверенном боевом духе."
		});
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к ОЗ"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к прочности"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] к выносливости"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к навыку ближнего боя при уверенном боевом духе."
		});
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к защите ближнего боя при уверенном боевом духе."
		});
		_result.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к защите дальнего боя при уверенном боевом духе."
		});
		_result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к ОЗ"
		});
		_result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к прочности"
		});
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] к выносливости"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Hitpoints += 20;

		if (this.getContainer() != null && this.getContainer().getActor() != null && this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Confident)
		{
			_properties.MeleeSkill *= 1.1;
			_properties.MeleeDefense *= 1.1;
			_properties.RangedDefense *= 1.1;
		}
	}

});

