this.cp_owl_item <- this.inherit("scripts/items/accessory/cp_bird", {
	m = {
		RangedDefenseBonus = 10,
	},

	function create()
	{
		this.cp_bird.create();
		this.m.ID = "accessory.cp_owl";
		this.m.Name = "Сова";
		this.m.Description = "Дрессированная сова, которая обеспечивает дальнобойную защиту, находясь рядом с персонажем. Может быть выпущена в бою, чтобы напугать врага.";
		this.m.Icon = "accessory/cp_owl.png";
		this.m.DefaultIcon = "accessory/cp_owl.png";
		this.m.DefaultSound = [
			"sounds/inventory/cp_owl_inventory_01.wav"
		];
		this.m.Value = 900;
	}

	function getTooltip()
	{
		local tooltip = this.cp_bird.getTooltip();

		local rangedDefenseBonus = this.getRangedDefense();
		if (!this.isReleased() && rangedDefenseBonus != 0)
		{
			tooltip.push({
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::MSU.Text.colorizeValue(rangedDefenseBonus, {AddSign = true}) + " к защите в дальнем бою"
			});
		}

		return tooltip;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		if (!this.isReleased())
		{
			_properties.RangedDefense += this.getRangedDefense();
		}
	}

	function onEquip()
	{
		this.cp_bird.onEquip();
		local skill = ::new("scripts/skills/actives/cp_release_owl_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

// New Functions
	function getRangedDefense()
	{
		return this.m.RangedDefenseBonus;
	}

});

