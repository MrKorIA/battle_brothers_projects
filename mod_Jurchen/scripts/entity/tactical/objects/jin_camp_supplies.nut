this.jin_camp_supplies <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Припасы";
	}

	function getDescription()
	{
		return "Припасы обитателей этого лагеря.";
	}

	function onInit()
	{
		local variants = ::MSU.Class.WeightedContainer([
			[1, "jin_camp_03"],
			[1, "jin_camp_04"],
			[1, "jin_camp_05"],
			[1, "jin_camp_16"]
		]);
		local body = this.addSprite("body");
		body.setBrush(variants.roll());
	}

});

