this.cultist_altar <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Алтарь";
	}

	function getDescription()
	{
		return "Жертвенный алтарь.";
	}

	function onInit()
	{

		local bottom = this.addSprite("bottom");
		bottom.setBrush("cultist_altar_bottom");
		local top = this.addSprite("top");
		top.setBrush("cultist_altar_top");
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(false);
	}

});

