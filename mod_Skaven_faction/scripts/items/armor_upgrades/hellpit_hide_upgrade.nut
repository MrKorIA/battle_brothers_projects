this.hellpit_hide_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.hellpit_hide";
		this.m.Name = "Плащ из Шкуры Мерзости Адской Ямы";
		this.m.Description = "Плащ, изготовленный из тонкой шкуры \'Мерзости Адской Ямы\', заставляет любого, кто атакует владельца, заражаться чумой.";
		this.m.ArmorDescription = "К этой броне прикреплён плащ из шкуры \'Мерзости Адской Ямы\', из-за которого любой, кто атакует владельца, заразится чумой.";
		this.m.Icon = "armor_upgrades/rat_upgrade_03.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_rat_upgrade_03.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_rat_upgrade_03.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "rat_upgrade_03_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "rat_upgrade_03_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "rat_upgrade_03_back_dead";
		this.m.Value = 800;
		this.m.StaminaModifier = 3;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+45[/color] к ОЗ"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-3[/color] к максимальной выносливости"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Любой, кто атакует владельца, заразится чумой"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+45[/color] к ОЗ"
		});
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Любой, кто атакует владельца, заразится чумой"
		});
	}

	function onEquip()
	{
		this.item.onEquip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().add(this.new("scripts/skills/racial/rat_racial"));
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().removeByID("racial.rat");
		}
	}

	function onAdded()
	{
		this.armor_upgrade.onAdded();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().add(this.new("scripts/skills/racial/rat_racial"));
		}
	}

	function onRemoved()
	{
		this.armor_upgrade.onRemoved();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().removeByID("racial.rat");
		}
	}

	function onUpdateProperties( _properties )
	{
		_properties.Hitpoints += 45;
	}

});

