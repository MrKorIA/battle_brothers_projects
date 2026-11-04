this.wushi_camp_supplies <- this.inherit("scripts/entity/tactical/entity", {
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
			[1, "wushi_camp_03"],
			[1, "wushi_camp_04"],
			[1, "wushi_camp_05"],
			[1, "wushi_camp_06"],
			[1, "wushi_camp_07"],
			[1, "wushi_camp_09"]
		]);
		local body = this.addSprite("body");
		body.setBrush(variants.roll());
	}

});

