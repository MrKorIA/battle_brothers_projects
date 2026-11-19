this.nggh_mod_named_stollwurm_scales_legend_upgrade <- ::inherit("scripts/items/legend_armor/legend_named_armor_upgrade", {
	m = {
		DefaultName = "Накидка из чешуи"
	},
	function create()
	{
		this.legend_named_armor_upgrade.create();
		this.m.ID = "legend_armor_upgrade.legend_stollwurm_scales";
		this.m.Type = ::Const.Items.ArmorUpgrades.Cloak;
		this.m.Name = "Накидка из чешуи штолльвурма";
		this.m.Description = "Накидка из чешуи штоллвурма - это не только редкая и внушительная добыча, она также хорошо защищает.";
		this.m.ArmorDescription = "Поверх этого доспеха надета накидка из чешуи штолльвурма, даруя дополнительную защиту.";
		this.m.Icon = "armor_upgrades/named_upgrade_stollwurm.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_stollwurm.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_stollwurm.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_stollwurm_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_stollwurm_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_stollwurm_back_dead";
		this.m.Value = 6000;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.ConditionModifier = 50;
		this.m.StaminaModifier = -4;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.m.StaminaModifier = ::Math.min(0, this.m.StaminaModifier + ::Math.rand(0, 2));
		this.m.Condition = ::Math.floor(this.m.Condition * ::Math.rand(115, 133) * 0.01) * 1.0;
		this.m.ConditionMax = this.m.Condition;
	}

	function setName( _prefix = "" )
	{
		if (this.m.DefaultName.len() == 0)
		{
			this.m.Name = _prefix;
			return;
		}

		if (_prefix.len() == 0)
		{
			this.m.Name = this.m.DefaultName;
			return;
		}

		this.m.Name = _prefix + " " + this.m.DefaultName;
	}

	function getTooltip()
	{
		local result = this.legend_named_armor_upgrade.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Невосприимчивость к оглушению, отталкиванию и захвату, а также к кислоте"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Невосприимчивость к оглушению, отталкиванию и захвату, а также к кислоте"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_named_armor_upgrade.onUpdateProperties(_properties);
		_properties.IsImmuneToStun = true;
		_properties.IsImmuneToKnockBackAndGrab = true;
	}

	function onEquip()
	{
		this.legend_named_armor_upgrade.onEquip();
		local c = this.m.Armor.getContainer();

		if (!::MSU.isNull(c) && !::MSU.isNull(c.getActor()))
			c.getActor().getFlags().add("body_immune_to_acid");
	}

	function onUnequip()
	{
		local c = this.m.Armor.getContainer();

		if (!::MSU.isNull(c) && !::MSU.isNull(c.getActor()))
			c.getActor().getFlags().remove("body_immune_to_acid");

		this.legend_named_armor_upgrade.onUnequip();
	}
});
