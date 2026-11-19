this.nggh_mod_named_unhold_fur_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.unhold_fur";
		this.m.Name = "Накидка из шкуры тролля";
		this.m.Description = "Накидка, сделанная из густого белого меха снежных троллей. Может носиться поверх любого доспеха, защищая владельца от оружия дальнего боя.";
		this.m.ArmorDescription = "Накидка из густого белого меха прикреплена к этому доспеху, защищая его от оружия дальнего боя.";
		this.m.Icon = "armor_upgrades/named_upgrade_02.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_02.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_02.png";
		this.m.SpriteFront = "upgrade_02_front";
		this.m.SpriteBack = "upgrade_02_back";
		this.m.SpriteDamagedFront = "upgrade_02_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_02_back";
		this.m.SpriteCorpseFront = "upgrade_02_front_dead";
		this.m.SpriteCorpseBack = "upgrade_02_back_dead";
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = 0;
		this.m.SpecialValue = 20;
		this.m.Value = 1000;
	}

	function randomizeValues()
	{
		this.nggh_mod_named_armor_upgrade.randomizeValues();
		this.m.SpecialValue = ::Math.min(30, ::Math.ceil(this.m.SpecialValue * ::Math.rand(115, 140) * 0.01));
	}

	function getTooltip()
	{
		local result = this.nggh_mod_named_armor_upgrade.getTooltip();
		result.push([
			{
				id = 13,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(this.m.ConditionModifier) + "[/color] к прочности"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Уменьшает получаемый урон в дальнем бою при попадании в тело на [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
			}
		]);
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уменьшает получаемый урон в дальнем бою при попадании в тело на [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart != ::Const.BodyPart.Body)
		{
			return;
		}

		_properties.DamageReceivedRangedMult *= 1.0 - this.m.SpecialValue * 0.01;
	}

});

