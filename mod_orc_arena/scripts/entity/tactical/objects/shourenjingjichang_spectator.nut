this.shourenjingjichang_spectator <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Зритель";
	}

	function getDescription()
	{
		return "Зритель, подбадривающий бойцов арены";
	}

	function setFlipped( _flip )
	{
		this.getSprite("body").setHorizontalFlipping(_flip);
		this.getSprite("head").setHorizontalFlipping(_flip);
		this.getSprite("armor").setHorizontalFlipping(_flip);
		this.getSprite("helmet").setHorizontalFlipping(_flip);
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("bust_orc_03_body");
		body.varyColor(0.09, 0.09, 0.09);
		body.varySaturation(0.1);
		local armor = this.addSprite("armor");

		if (this.Math.rand(1, 100) <= 95)
		{
			local armors = [
				"bust_orc_03_armor_01",
				"bust_orc_03_armor_02",
				"bust_orc_03_armor_03",
				"bust_orc_03_armor_04"
				
			];
			armor.setBrush(armors[this.Math.rand(0, armors.len() - 1)]);
		}

		local head = this.addSprite("head");
		head.setBrush("bust_orc_03_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local helmet = this.addSprite("helmet");

		if (this.Math.rand(1, 100) <= 95)
		{
			local helmets = [
				"bust_orc_03_helmet_01",
				"bust_orc_03_helmet_02",
				"bust_orc_03_helmet_03",
				"bust_orc_03_helmet_04",
				"bust_orc_03_helmet_05",
				"bust_orc_03_helmet_06"
			];
			helmet.setBrush(helmets[this.Math.rand(0, helmets.len() - 1)]);
		}
		
	}

});

