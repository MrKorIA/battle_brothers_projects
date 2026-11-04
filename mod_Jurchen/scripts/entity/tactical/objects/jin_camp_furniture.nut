this.jin_camp_furniture <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Мебель";
	}

	function getDescription()
	{
		return "Деревянная мебель обитателей этого лагеря.";
	}

	function onInit()
	{
		local variants = ::MSU.Class.WeightedContainer([
			[1, "jin_camp_14"],
			[1, "desert_camp_04"]
		]);
		local body = this.addSprite("body");
		body.setBrush(variants.roll());
	}

});

