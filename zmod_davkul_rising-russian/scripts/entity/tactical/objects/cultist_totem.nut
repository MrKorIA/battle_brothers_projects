this.cultist_totem <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Идол";
	}

	function getDescription()
	{
		return "Идол культистов.";
	}

	function onInit()
	{
		local variants = [
			"04"
		];
		local v = variants[this.Math.rand(0, variants.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("cultists_" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		local top = this.addSprite("top");
		top.setBrush("cultists_" + v + "_top");
		top.setHorizontalFlipping(flip);
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(true);
	}

});

