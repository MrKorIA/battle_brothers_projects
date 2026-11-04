this.mgl_camp_supplies <- this.inherit("scripts/entity/tactical/entity", {
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
			[1, "camp_03"],
			[1, "camp_12"],
			[1, "desert_camp_01"],
			[1, "mgl_camp_01"],
			[1, "mgl_camp_03"],
			[1, "mgl_camp_04"],
			[1, "mgl_camp_05"],
			[1, "mgl_camp_06"]
		]);
		local body = this.addSprite("body");
		body.setBrush(variants.roll());
	}

});

