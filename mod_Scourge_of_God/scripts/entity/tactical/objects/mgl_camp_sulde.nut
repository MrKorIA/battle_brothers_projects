this.mgl_camp_sulde <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Сульде";
	}

	function getDescription()
	{
		return "Штандарт, изготовленный из грив специально отобранных жеребцов — белых и чёрных и привязанных к копью.";
	}

	function onInit()
	{
		local variants = [
			"07",
			"08"
		];
		local v = variants[this.Math.rand(0, variants.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("mgl_camp_" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		local top = this.addSprite("top");
		top.setBrush("mgl_camp_" + v + "_top");
		top.setHorizontalFlipping(flip);
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(false);
	}

});

