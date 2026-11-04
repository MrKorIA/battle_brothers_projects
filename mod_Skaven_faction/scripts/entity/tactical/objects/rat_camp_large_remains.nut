this.rat_camp_large_remains <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Жуткая демонстрация";
	}

	function getDescription()
	{
		return "Содранная кожа и кишки напоказ.";
	}

	function onInit()
	{
		local flip = this.Math.rand(0, 1) == 1;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("rat_11_bottom");
		bottom.setHorizontalFlipping(flip);
		local top = this.addSprite("top");
		top.setBrush("rat_11_top");
		top.setHorizontalFlipping(flip);
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(false);
	}

});

