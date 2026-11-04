this.xxhero_baku_background <- this.inherit("scripts/skills/backgrounds/xxhero_background", {
	m = {},
	function create()
	{
		this.xxhero_background.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local xhair = actor.getSprite("hair");
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local pp;
		local hair_type = [
			"hair_brown_02",
			"hair_brown_03",
			"hair_brown_04",
			"hair_brown_08",
			"hair_brown_21",
			"hair_beast_01",
			"hair_beast_02",
			"hair_beast_03",
			"hair_beast_04",
			"hair_beast_04",
			"hair_beast_05",
			"hair_beast_05",
			"hair_beast_05"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
		local body_type = [
			"7873",
			"7873",
			"7874"
		];
		body_type = body_type[this.Math.rand(0, body_type.len() - 1)]
		xbody.setBrush("bust_naked_body_" + body_type);
		xhead.setBrush("bust_head_788" + this.Math.rand(0, 2));
		xhair.setBrush(hair_type);
		pp = this.Math.rand(1, 3);
		if (pp == 1)
		{
			tattoo_body.setBrush("tattoo_0" + this.Math.rand(2, 4) + "_bust_naked_body_02");
			tattoo_head.setBrush("tattoo_01_head");
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		else
		if (pp == 2)
		{
			tattoo_body.setBrush("warpaint_01_bust_naked_body_02");
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		xhead.varyColor(0.05, 0.05, 0.05);
		xbody.Color = xhead.Color;
	}

});

