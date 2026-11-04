this.mgl_camp_small_idol <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Идол";
	}

	function getDescription()
	{
		return "Ордынский идол.";
	}

	function onInit()
	{
		local variants = [
			"orcs_08",
			"mgl_camp_02"
		];
		local body = this.addSprite("body");
		body.setBrush(variants[this.Math.rand(0, variants.len() - 1)]);
	}

});



