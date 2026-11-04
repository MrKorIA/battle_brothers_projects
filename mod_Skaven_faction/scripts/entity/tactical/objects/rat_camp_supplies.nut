this.rat_camp_supplies <- this.inherit("scripts/entity/tactical/entity", {
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
		local variants = [
			"01",
			"04",
			"05"
		];
		local body = this.addSprite("body");
		body.setBrush("rat_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

