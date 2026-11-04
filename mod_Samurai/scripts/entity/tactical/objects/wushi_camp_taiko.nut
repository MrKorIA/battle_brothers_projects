this.wushi_camp_taiko <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Сигнальные барабаны";
	}

	function getDescription()
	{
		return "Большие боевые барабаны на подставках, в которые бьют для отдачи приказов.";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("wushi_camp_08");
	}

});

