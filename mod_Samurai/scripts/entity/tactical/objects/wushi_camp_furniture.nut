this.wushi_camp_furniture <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Мебель";
	}

	function getDescription()
	{
		return "Деревянная мебель обитателей этого лагеря.";
	}

	function onInit()
	{
		local variants = [
			"04"
		];
		local body = this.addSprite("body");
		body.setBrush("desert_camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

