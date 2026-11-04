this.cultist_campfire <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Костёр";
	}

	function getDescription()
	{
		return "Костёр для готовки пищи.";
	}

	function onInit()
	{
		local variants = [
			"08"
		];
		local body = this.addSprite("body");
		body.setBrush("cultists_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

