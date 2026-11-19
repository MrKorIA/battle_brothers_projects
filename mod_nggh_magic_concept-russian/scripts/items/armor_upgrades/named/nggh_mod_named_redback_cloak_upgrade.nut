this.nggh_mod_named_redback_cloak_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.legend_redback_cloak";
		this.m.DefaultName = "Шёлковая накидка";
		this.m.Description = "Эта струящаяся накидка соткана из паутины, даруя отличную защиту от дальних атак.";
		this.m.ArmorDescription = "Накидка из паучьего шёлка обеспечивает дополнительную защиту";
		this.m.Icon = "armor_upgrades/named_upgrade_cloak_black.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_cloak_black.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_cloak_black.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "cloak_black";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "cloak_black_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "cloak_black_dead";
		this.m.Value = 5000;
		this.m.ConditionModifier = 10;
		this.m.SpecialValue = 50;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.nggh_mod_named_armor_upgrade.randomizeValues();
		this.m.SpecialValue = ::Math.min(60, ::Math.ceil(this.m.SpecialValue * ::Math.rand(105, 120) * 0.01));
	}

	function getTooltip()
	{
		local result = this.nggh_mod_named_armor_upgrade.getTooltip();
		result.extend([
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
				text = "Уменьшает получаемый урон в дальнем бою при попадании в тело на color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
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
			text = "Уменьшает получаемый урон в дальнем бою при попадании в тело на color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
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

