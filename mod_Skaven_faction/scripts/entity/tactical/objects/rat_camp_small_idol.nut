this.rat_camp_small_idol <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Кристалл";
	}

	function getDescription()
	{
		return "Зелёный кристалл.";
	}

	function onInit()
	{
		local variants = [
			"08"
		];
		local body = this.addSprite("body");
		body.setBrush("rat_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

