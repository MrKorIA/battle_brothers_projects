this.rat_camp_fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Очаг";
	}

	function getDescription()
	{
		return "Очаг. Вы не хотите знать, что здесь готовят.";
	}

	function onInit()
	{
		local variants = [
			"06",
			"09"
		];
		local body = this.addSprite("body");
		body.setBrush("rat_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

