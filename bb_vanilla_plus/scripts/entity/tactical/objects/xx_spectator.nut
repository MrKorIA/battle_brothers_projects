this.xx_spectator <- this.inherit("scripts/entity/tactical/objects/arena_spectator", {
	m = {},
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
		local sr = 0.8;
		local br = 0.6;
		local socket = this.addSprite("socket");
		socket.setBrush("bust_base_militia");
		socket.Saturation = sr;
		socket.setBrightness(br);
		local body = this.addSprite("body");
		body.setBrush(this.Const.Bodies.AllMale[this.Math.rand(0, this.Const.Bodies.AllMale.len() - 1)]);
		body.Saturation = sr;
		body.setBrightness(br);
		body.varyColor(0.05, 0.05, 0.05);
		body.varySaturation(0.1);

		local armor = this.addSprite("armor");
		if (this.Math.rand(1, 100) <= 99)
		{
			local armors = [
				"bust_body_01",
				"bust_body_02",
				"bust_body_03",
				"bust_body_04",
				"bust_body_05",
				"bust_body_06",
				"bust_body_07",
				"bust_body_08",
				"bust_body_01",
				"bust_body_02",
				"bust_body_03",
				"bust_body_04",
				"bust_body_05",
				"bust_body_06",
				"bust_body_07",
				"bust_body_08",
				"bust_body_13",
				"bust_body_14",
				"bust_body_15",
				"bust_body_19",
				"bust_body_20",
				"bust_body_southern_13",
				"bust_body_southern_16",
				"bust_body_southern_17"
			];
			armor.setBrush(armors[this.Math.rand(0, armors.len() - 1)]);
		}
		armor.Saturation = sr;
		armor.setBrightness(br);

		local head = this.addSprite("head");
		head.setBrush(this.Const.Faces.AllMale[this.Math.rand(0, this.Const.Faces.AllMale.len() - 1)]);
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local hcolor = this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)]

		local beard = this.addSprite("beard");
		if (this.Math.rand(1, 100) <= 50)
		{
			beard.setBrush("beard_" + hcolor + "_" + this.Const.Beards.All[this.Math.rand(0, this.Const.Beards.All.len() - 1)]);
			beard.Saturation = sr;
			beard.setBrightness(br);
		}

		local hair = this.addSprite("hair");
		local helmet = this.addSprite("helmet");
		if (this.Math.rand(1, 100) <= 77)
		{
			hair.setBrush("hair_" + hcolor + "_" + this.Const.Hair.AllMale[this.Math.rand(0, this.Const.Hair.AllMale.len() - 1)]);
			hair.Saturation = sr;
			hair.setBrightness(br);
		}
		else
		{
			local helmets = [
				"bust_helmet_21",
				"bust_helmet_25",
				"bust_helmet_26",
				"bust_helmet_34",
				"bust_helmet_36",
				"bust_helmet_37",
				"bust_helmet_38",
				"bust_helmet_39",
				"bust_helmet_40",
				"bust_helmet_42"
			];
			helmet.setBrush(helmets[this.Math.rand(0, helmets.len() - 1)]);
			helmet.Saturation = sr;
			helmet.setBrightness(br);
		}

		local beard_top = this.addSprite("beard_top");
		if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
		{
			beard_top.setBrush(beard.getBrush().Name + "_top");
			beard_top.Saturation = sr;
			beard_top.setBrightness(br);
		}
	}

});

