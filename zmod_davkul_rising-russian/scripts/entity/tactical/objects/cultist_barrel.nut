this.cultist_barrel <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Бочка";
	}

	function getDescription()
	{
		return "Эта бочка наполнена неописуемыми вещами.";
	}

	function onInit()
	{
		local variants = [
			"05", "05a"
		];
		local body = this.addSprite("body");
		body.setBrush("cultists_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

