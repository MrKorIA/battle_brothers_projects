this.cultist_small_spike <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Пика";
	}

	function getDescription()
	{
		return "Пика, на которую насажена чья-то голова.";
	}

	function onInit()
	{
		local variants = [
			"09", "10"
		];
		local body = this.addSprite("body");
		body.setBrush("cultists_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

