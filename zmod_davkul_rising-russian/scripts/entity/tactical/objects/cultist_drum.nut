this.cultist_drum <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Кожаный барабан";
	}

	function getDescription()
	{
		return "Барабан из человеческой кожи.";
	}

	function onInit()
	{
		local variants = [
			"04"
		];
		local body = this.addSprite("body");
		body.setBrush("cultists_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

