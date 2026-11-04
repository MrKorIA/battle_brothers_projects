this.cp_vulture_item <- this.inherit("scripts/items/accessory/cp_bird", {
	m = {
		ThreatModifier = 10,
	},

	function create()
	{
		this.cp_bird.create();
		this.m.ID = "accessory.cp_vulture";
		this.m.Name = "Стервятник";
		this.m.Description = "Обученный стервятник, который отпугивает ближайших врагов, пока находится рядом с персонажем. Можно выпустить его в бою, чтобы он сожрал труп.";
		this.m.Icon = "accessory/cp_vulture.png";
		this.m.DefaultIcon = "accessory/cp_vulture.png";
		this.m.DefaultSound = [
			"sounds/inventory/cp_vulture_inventory_01.wav",
			"sounds/inventory/cp_vulture_inventory_02.wav"
		];
		this.m.Value = 1800;
	}

	function getTooltip()
	{
		local tooltip = this.cp_bird.getTooltip();

		if (!this.isReleased() && this.m.ThreatModifier != 0)
		{
			tooltip.push({
				id = 10,
				type = "text",
				icon = "ui/icons/kills.png",
				text = "Ближайшие враги теряют " + ::MSU.Text.colorizeValue(-1 * this.m.ThreatModifier, {AddSign = true}) + " решимости во время проверки боевого духа."
			});
		}

		return tooltip;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		if (!this.isReleased())
		{
			_properties.Threat += this.m.ThreatModifier;
		}
	}

	function onEquip()
	{
		this.cp_bird.onEquip();
		local skill = ::new("scripts/skills/actives/cp_release_vulture_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

});

