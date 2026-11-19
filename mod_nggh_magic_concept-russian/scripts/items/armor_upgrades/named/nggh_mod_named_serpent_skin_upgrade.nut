this.nggh_mod_named_serpent_skin_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.serpent_skin";
		this.m.DefaultName = "Накидка из змеиной кожи";
		this.m.Description = "Накидка, сделанная из тонкой и блестящей чешуи пустынных змей, особенно устойчива к жаре и пламени.";
		this.m.ArmorDescription = "К этой броне была прикреплена накидка из змеиной кожи, что делает её более устойчивой к жаре и огню.";
		this.m.Icon = "armor_upgrades/named_upgrade_27.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_27.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_27.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_27_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_27_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_27_back_dead";
		this.m.Value = 1000;
		this.m.ConditionModifier = 35;
		this.m.StaminaModifier = -3;
		this.randomizeValues();
	}

	function getTooltip()
	{
		local result = this.nggh_mod_named_armor_upgrade.getTooltip();
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(this.m.ConditionModifier) + "[/color] к прочности"
		});

		if (this.m.StaminaModifier < 0)
		{
			result.push({
				id = 14,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color] к выносливости"
			});
		}

		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Снижает получаемый урон от огня и огнестрельного оружия на [color=" + ::Const.UI.Color.NegativeValue + "]33%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Снижает получаемый урон от огня и огнестрельного оружия на [color=" + ::Const.UI.Color.NegativeValue + "]33%[/color]"
		});
	}

	function onEquip()
	{
		this.item.onEquip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().add(::new("scripts/skills/items/firearms_resistance_skill"));
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().removeByID("items.firearms_resistance");
		}
	}

	function onAdded()
	{
		this.armor_upgrade.onAdded();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().add(::new("scripts/skills/items/firearms_resistance_skill"));
		}
	}

	function onRemoved()
	{
		this.armor_upgrade.onRemoved();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getSkills().removeByID("items.firearms_resistance");
		}
	}

});

