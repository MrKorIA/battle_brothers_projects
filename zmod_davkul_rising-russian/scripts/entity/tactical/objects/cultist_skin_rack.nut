this.cultist_skin_rack <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Стойка для кожи";
	}

	function getDescription()
	{
		return "Каркас, на котором растянута кожа недавней жертвы.";
	}

	function onInit()
	{
		local variants = [
			"02"
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

