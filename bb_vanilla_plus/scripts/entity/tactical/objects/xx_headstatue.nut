this.xx_headstatue <- this.inherit("scripts/entity/tactical/objects/orc_camp_head", {
	m = {},
	function onInit()
	{
		local variants = [
			"orcs_15",
			"orcs_16"
		];
		local body = this.addSprite("body");
		body.setBrush(variants[this.Math.rand(0, variants.len() - 1)]);
		body.setHorizontalFlipping(this.Math.rand(0, 1) == 1);
		body.varyColor(0.2, 0.2, 0.2);
		body.varySaturation(0.2);
	}

});

