this.yemanrenjingjichang_spectator <- this.inherit("scripts/entity/tactical/entity", {
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
		this.getSprite("beard").setHorizontalFlipping(_flip);
		this.getSprite("helmet").setHorizontalFlipping(_flip);
		this.getSprite("hair").setHorizontalFlipping(_flip);
		this.getSprite("beard_top").setHorizontalFlipping(_flip);
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush(this.Const.Bodies.SouthernMale[this.Math.rand(0, this.Const.Bodies.SouthernMale.len() - 1)]);
		body.varyColor(0.05, 0.05, 0.05);
		body.varySaturation(0.1);
		local armor = this.addSprite("armor");

		if (this.Math.rand(1, 100) <= 95)
		{
			local armors = [
				"bust_body_93",
				"bust_body_94",
				"bust_body_95",
				"bust_body_96",
				"bust_body_102",
				"bust_body_103",
				"bust_body_104",
				"bust_body_105"
				
			];
			armor.setBrush(armors[this.Math.rand(0, armors.len() - 1)]);
		}

		local head = this.addSprite("head");
		head.setBrush(this.Const.Faces.WildMale[this.Math.rand(0, this.Const.Faces.WildMale.len() - 1)]);
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local beard = this.addSprite("beard");

		if (this.Math.rand(1, 100) <= 60)
		{
			beard.setBrush("beard_brown_" + this.Const.Beards.WildExtended[this.Math.rand(0, this.Const.Beards.WildExtended.len() - 1)]);
			beard.Saturation = 0.8;
			beard.setBrightness(0.4);
		}

		local hair = this.addSprite("hair");
		local helmet = this.addSprite("helmet");

		if (!beard.HasBrush)
		{
			local helmets = [
				"bust_helmet_189",
				"bust_helmet_190",
				"bust_helmet_191",
				"bust_helmet_192",
				"bust_helmet_193",
				"bust_helmet_194",
				"bust_helmet_196",
				"bust_helmet_197",
				"bust_helmet_232"
			];
			helmet.setBrush(helmets[this.Math.rand(0, helmets.len() - 1)]);
		}
		else if (this.Math.rand(1, 100) <= 95)
		{
			hair.setBrush("hair_brown_" + this.Const.Hair.WildMale[this.Math.rand(0, this.Const.Hair.WildMale.len() - 1)]);
			hair.Saturation = 0.8;
			hair.setBrightness(0.4);
		}

		local beard_top = this.addSprite("beard_top");

		if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
		{
			beard_top.setBrush(beard.getBrush().Name + "_top");
			beard_top.Saturation = 0.8;
			beard_top.setBrightness(0.4);
		}
	}

});

