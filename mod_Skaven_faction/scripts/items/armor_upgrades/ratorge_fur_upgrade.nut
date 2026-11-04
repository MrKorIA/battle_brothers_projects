this.ratorge_fur_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.ratorge_fur";
		this.m.Name = "Плащ из Меха крысоогра";
		this.m.Description = "Толстый плащ, сделанный из величественного коричневого меха крысоогра. Может носиться поверх любой брони, делая владельца невосприимчивым к любым видам чумы.";
		this.m.ArmorDescription = "К этой броне прикреплён плащ из толстого коричневого меха, чтобы сделать её невосприимчивой к любым видам чумы.";
		this.m.Icon = "armor_upgrades/rat_upgrade_01.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_rat_upgrade_01.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_rat_upgrade_01.png";
		this.m.SpriteFront = "rat_upgrade_01_front";
		this.m.SpriteBack = "rat_upgrade_01_back";
		this.m.SpriteDamagedFront = "rat_upgrade_01_front_damaged";
		this.m.SpriteDamagedBack = "rat_upgrade_01_back";
		this.m.SpriteCorpseFront = "rat_upgrade_01_front_dead";
		this.m.SpriteCorpseBack = "rat_upgrade_01_back_dead";
		this.m.StaminaModifier = 0;
		this.m.Value = 1000;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] к ОЗ"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Невосприимчив к любым видам чумы"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] к ОЗ"
		});
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Невосприимчив к любым видам чумы"
		});
	}

	function onEquip()
	{
		this.item.onEquip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("rat");
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("rat");
		}
	}

	function onAdded()
	{
		this.armor_upgrade.onAdded();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("rat");
		}
	}

	function onRemoved()
	{
		this.armor_upgrade.onRemoved();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("rat");
		}
	}

	function onUpdateProperties( _properties )
	{
		_properties.Hitpoints += 15;
	}

});

