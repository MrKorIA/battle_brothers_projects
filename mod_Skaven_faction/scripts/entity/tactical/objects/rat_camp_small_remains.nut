this.rat_camp_small_remains <- this.inherit("scripts/entity/tactical/entity", {
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
			"02",
			"03"
		];
		local body = this.addSprite("body");
		body.setBrush("rat_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

