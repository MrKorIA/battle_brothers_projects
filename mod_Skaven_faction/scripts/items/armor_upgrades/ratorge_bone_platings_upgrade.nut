this.ratorge_bone_platings_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {
		IsUsed = false
	},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_ratorge_upgrade.bone_platings";
		this.m.Name = "Костяная Броня крысоогра";
		this.m.Description = "Изготовленные из крепких костей крысоогра, эти украшенные пластины служат абляционной бронёй, которую крепят к обычной броне.";
		this.m.ArmorDescription = "К этой броне прикреплён слой костяных пластин крысоогра.";
		this.m.Icon = "armor_upgrades/rat_upgrade_04.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_rat_upgrade_04.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_rat_upgrade_04.png";
		this.m.SpriteFront = "rat_upgrade_04_front";
		this.m.SpriteBack = "rat_upgrade_04_back";
		this.m.SpriteDamagedFront = "rat_upgrade_04_front_damaged";
		this.m.SpriteDamagedBack = "rat_upgrade_04_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "rat_upgrade_04_back_dead";
		this.m.StaminaModifier = 2;
		this.m.Value = 850;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к ОЗ"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уменьшает получаемый урон по телу в ближнем бою на [color=" + this.Const.UI.Color.NegativeValue + "]15%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к ОЗ"
		});
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уменьшает получаемый урон по телу в ближнем бою на [color=" + this.Const.UI.Color.NegativeValue + "]15%[/color]"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart == this.Const.BodyPart.Body)
		{
			_properties.DamageReceivedMeleeMult *= 0.85;
		}
	}

	function onUpdateProperties( _properties )
	{
		_properties.Hitpoints += 10;
	}

});

