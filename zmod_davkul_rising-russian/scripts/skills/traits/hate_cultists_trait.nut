this.hate_cultists_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.hate_cultists";
		this.m.Name = "Ненависть к культистам";
		this.m.Icon = "ui/traits/hate_cultists.png";
		this.m.Description = "Некие события, пережитые этим персонажем, вызвало в нём жгучую ненависть к культистам Давкула.";
		this.m.Excluded = [
			"trait.weasel",
			"trait.craven",
			"trait.dastard",
			"trait.fainthearted",
			"trait.fear_cultists",
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к решимости в битвах с вражескими культистами"
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
			_properties.Bravery += 10;
		}
	}

});

