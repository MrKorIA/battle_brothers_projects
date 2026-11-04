this.cultist_cooking_pot <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Кухонный котелок";
	}

	function getDescription()
	{
		return "Кухонный котелок, в котором готовится здоровая пища.";
	}

	function onInit()
	{
		local variants = [
			"06"
		];
		local body = this.addSprite("body");
		body.setBrush("cultists_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

