this.rat_camp_head <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Голова на колу";
	}

	function getDescription()
	{
		return "Жуткая демонстрация того, что здесь случается с людьми.";
	}

	function setFlipped( _flip )
	{
		this.getSprite("body").setHorizontalFlipping(_flip);
	}

	function setVariant( _variant )
	{
		local variants = [
			"15",
			"16"
		];
		this.getSprite("body").setBrush("rat_" + variants[_variant]);
	}

	function onInit()
	{
		this.addSprite("body");
	}

});

