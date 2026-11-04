this.fear_cultists_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.fear_cultists";
		this.m.Name = "Боязнь культистов";
		this.m.Icon = "ui/traits/fear_cultists.png";
		this.m.Description = "Недавний опыт на поле боя заставил этого персонажа смертельно бояться культистов Давкула.";
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.cocky",
			"trait.bloodthirsty",
			"trait.hate_cultists",
			"background.cultist",
			"background.converted_cultist"
		];
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] к решимости в битвах с вражескими культистами"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}

		if (this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).getID()) != 0)
		{
			_properties.Bravery -= 10;
		}
	}

});

