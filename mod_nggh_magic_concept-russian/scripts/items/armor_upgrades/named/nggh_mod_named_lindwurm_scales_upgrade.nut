this.nggh_mod_named_lindwurm_scales_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.lindwurm_scales";
		this.m.DefaultName = "Накидка из чешуи";
		this.m.Description = "Накидка из чешуи линдвурма - это не только редкая и внушительная добыча, она также хорошо защищает, а едкая кровь линдвурма не в силах ей навредить.";
		this.m.ArmorDescription = "Поверх этого доспеха надета накидка из чешуи линдвурма, которая, помимо дополнительной защиты, невосприимчива к его разъедающей крови.";
		this.m.Icon = "armor_upgrades/named_upgrade_04.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_04.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_04.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_04_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_04_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_04_back_dead";
		this.m.Value = 2000;
		this.m.ConditionModifier = 60;
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
			text = "Невосприимчивость к едкой крови линдвурма"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Невосприимчивость к едкой крови линдвурма"
		});
	}

	function onEquip()
	{
		this.item.onEquip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("body_immune_to_acid");
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("body_immune_to_acid");
		}
	}

	function onAdded()
	{
		this.armor_upgrade.onAdded();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("body_immune_to_acid");
		}
	}

	function onRemoved()
	{
		this.armor_upgrade.onRemoved();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("body_immune_to_acid");
		}
	}

});

