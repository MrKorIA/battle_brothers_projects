this.xxhero_orc_background <- this.inherit("scripts/skills/backgrounds/xxhero_background", {
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
		this.m.Names = this.Const.Strings.OrcWarlordNames;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local hair_color = [
			"black",
			"grey",
			"brown"
		];
		hair_color = hair_color[this.Math.rand(0, hair_color.len() - 1)]
		local hair_type = [
			"09",
			"19",
			"21"
		];
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local pp;
		xbody.setBrush("bust_naked_body_7872");
		xhead.setBrush("bust_head_790" + this.Math.rand(0, 2));
		pp = this.Math.rand(1, 2);
		if (pp == 1)
		{
			pp = this.Math.rand(0, hair_type.len() - 1);
			hair_type = hair_type[pp]
			actor.getSprite("hair").setBrush("hair_" + hair_color + "_" + hair_type);
			if (pp == 1)
			{
				actor.getSprite("beard").setBrush("beard_" + hair_color + "_08");
				actor.getSprite("beard").Visible = true;
			}
		}		
		pp = this.Math.rand(1, 3);
		if (pp == 1)
		{
			tattoo_body.setBrush("scar_01_bust_naked_body_southern_02");
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Saturation = 1.2;
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		else
		if (pp == 2)
		{
			tattoo_body.setBrush("warpaint_01_bust_naked_body_02");
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_body.Color = this.createColor("#ff0000");
			tattoo_head.Color = this.createColor("#ff0000");
			tattoo_body.Saturation = 1.2;
			tattoo_head.Saturation = 1.2;
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		xhead.varyColor(0.05, 0.05, 0.05);
		xbody.Color = xhead.Color;
	}

	function onAdded()
	{
		this.xxhero_background.onAdded();
		if (!this.getContainer().getActor().getSkills().hasSkill("effects.xxzzvoice_skill"))
		{
			local actor = this.getContainer().getActor();
			actor.getSkills().add(this.new("scripts/skills/actives/xxzzvoice_skill"));
			actor.getFlags().add("xxzzvoice_orc");
		}
	}

});

