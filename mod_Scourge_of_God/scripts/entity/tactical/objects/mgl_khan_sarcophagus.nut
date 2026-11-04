this.mgl_khan_sarcophagus <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Саркофаг Великого Хана";
	}

	function getDescription()
	{
		return "Вероятно, это место последнего упокоения давно умершего Великого Хана Железной Орды.";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("mgl_khan_sarcophagus");
		body.setHorizontalFlipping(this.Math.rand(0, 1) == 1);
		this.setBlockSight(true);
	}

});

