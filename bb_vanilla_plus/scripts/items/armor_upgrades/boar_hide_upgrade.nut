this.boar_hide_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.boar_hide";
		this.m.Name = "Шипованные наплечники";
		this.m.Description = "Прочные наплечники изготовленные из панциря анхега и шипов шиповепря. Любой кто атакует получает урон от шипов, уменьшая броню нападавшего, если броня сломана, то накладывает кровотечение.";
		this.m.ArmorDescription = "К этой броне прикреплены шипы Шиповепря, из-за которых любой, кто атакует владельца, получает урон, уменьшая броню нападавшего, если броня сломана, то накладывает кровотечение.";
		this.m.Icon = "armor_upgrades/boar_upgrade.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_boar_upgrade.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_boar_upgrade.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "boar_upgrade_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "boar_upgrade_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "boar_upgrade_back_dead";
		this.m.ConditionModifier = 40;
		this.m.Value = 550;
		this.m.StaminaModifier = 3;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+40[/color] к прочности"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-3[/color] к выносливости"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Любой, кто атакует владельца, получает урон от шипов, уменьшая броню нападавшего, если броня сломана, то накладывает кровотечение"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Любой, кто атакует владельца, получает урон от шипов, уменьшая броню нападавшего, если броня сломана, то накладывает кровотечение"
		});
	}

	function onEquip()
	{
		this.item.onEquip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().add(this.new("scripts/skills/actives/ai_boar_passive"));
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().removeByID("effects.ai_boar_passive");
		}
	}

	function onAdded()
	{
		this.armor_upgrade.onAdded();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().add(this.new("scripts/skills/actives/ai_boar_passive"));
		}
	}

	function onRemoved()
	{
		this.armor_upgrade.onRemoved();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().removeByID("effects.ai_boar_passive");
		}
	}

});

