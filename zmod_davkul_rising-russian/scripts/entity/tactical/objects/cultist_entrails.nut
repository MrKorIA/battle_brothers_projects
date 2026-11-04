this.cultist_entrails <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Внутренности";
	}

	function getDescription()
	{
		return "Остатки какого-то бедняги.";
	}

	function onInit()
	{
		local variants = [
			"02", "03"
		];
		local body = this.addSprite("body");
		body.setBrush("cultists_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

