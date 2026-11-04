this.xxhero_undead_background <- this.inherit("scripts/skills/backgrounds/xxhero_background", {
	m = {},
	function create()
	{
		this.xxhero_background.create();
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.AncientDeadNames;
	}

	function onSetAppearance()
	{
	  local zxtype = this.Math.rand(0, 2);
	  if (zxtype == 1)
	  {
		local actor = this.getContainer().getActor();
		local body = actor.getSprite("body");
		body.setBrush("bust_skeleton_body_0" + this.Math.rand(1, 2));
		body.Saturation = 0.8;
		body.varySaturation(0.2);
		body.varyColor(0.025, 0.025, 0.025);
		local head = actor.getSprite("head");
		head.setBrush("bust_skeleton_head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local hair_type = [
			"hair_grey_02",
			"hair_grey_03",
			"hair_grey_06",
			"hair_grey_07",
			"hair_grey_08",
			"hair_grey_09",
			"hair_grey_10",
			"hair_grey_13",
			"hair_grey_14",
			"hair_grey_15",
			"hair_grey_21",
			"hair_black_zombie_02",
			"hair_grey_zombie_03",
			"hair_grey_zombie_04",
			"hair_grey_zombie_05",
			"hair_grey_zombie_06",
			"hair_grey_zombie_07"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
		actor.getSprite("hair").setBrush(hair_type);
		if (this.Math.rand(1, 2) != 2)
		{
			local beard_type = [
				"beard_grey_01",
				"beard_grey_04",
				"beard_grey_07",
				"beard_grey_09",
				"beard_grey_08",
				"beard_grey_12",
				"beard_grey_17",
				"beard_grey_zombie_04_top"
			];
			beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)]
			actor.getSprite("beard_top").setBrush(beard_type);
		}
	  }
	  else if (zxtype == 2)
	  {
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_z1"))
		{
			actor.getSprite("permanent_injury_z1").Visible = false;
			actor.removeSprite("permanent_injury_z1");
		}
		actor.addSprite("permanent_injury_z1");
		actor.getSprite("permanent_injury_z1").setBrush("zombie_rage_eyes");
		actor.getSprite("permanent_injury_z1").Visible = true;
		actor.getSprite("permanent_injury_z1").Color = this.createColor("#333333");
		actor.getSprite("permanent_injury_z1").Saturation = 0.5;
		local tattoo_head_type = [
			"bust_skeleton_face_01",
			"bust_skeleton_face_03",
			"bust_skeleton_face_04",
			"bust_skeleton_face_05",
			"bust_skeleton_face_06",
			"zombify_01",
			"zombify_03",
			"zombify_04",
			"zombify_03_injured",
			"zombify_04_injured",
			"zombify_01",
			"zombify_03"
		];
		actor.getSprite("tattoo_head").setBrush(tattoo_head_type[this.Math.rand(0, tattoo_head_type.len() - 1)]);
		actor.getSprite("tattoo_head").Visible = true;
		actor.getSprite("tattoo_head").Saturation = 0.7;
		actor.getSprite("head").Saturation = 0.5;
		actor.getSprite("head").varySaturation(0.1);
		actor.getSprite("body").Saturation = actor.getSprite("head").Saturation;
		if (this.Math.rand(0, 1) == 1)
		{
			local r = this.Math.rand(1, 2);
			actor.getSprite("beard").setBrush("beard_grey_southern_0" + r);
			actor.getSprite("beard_top").setBrush("beard_grey_southern_0" + r + "_top");
		}
		actor.getSprite("body").setBrush("bust_naked_body_0" + this.Math.rand(0, 2));
		actor.getSprite("head").setBrush("bust_head_" + this.Math.rand(10, 20));
		actor.getSprite("hair").setBrush("hair_grey_zombie_0" + this.Math.rand(1, 7));
	  }
	  else
	  {
		local actor = this.getContainer().getActor();
		local hair_color = this.Const.HairColors.All[this.Math.rand(0, 4)];
		local hair_type = [
			"02",
			"03",
			"04",
			"06",
			"07",
			"08",
			"10",
			"13",
			"14",
			"15",
			"16",
			"18",
			"19",
			"southern_03",
			"southern_03",
			"southern_03",
			"southern_03",
			"southern_03",
			"southern_05",
			"southern_05",
			"southern_05",
			"21"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
		local hair_type_zombie = [
			"hair_black_zombie_03",
			"hair_black_zombie_05",
			"hair_black_zombie_06",
			"hair_black_zombie_07",
			"hair_grey_zombie_03",
			"hair_grey_zombie_05",
			"hair_grey_zombie_06",
			"hair_grey_zombie_07"
		];
		hair_type_zombie = hair_type_zombie[this.Math.rand(0, hair_type_zombie.len() - 1)]
		local beard_type = [
			"14",
			"southern_01",
			"southern_02"
		];
		beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)]
		local pp = this.Math.rand(0, 1);
		if (pp == 0)
		{
			pp = this.Math.rand(3, 5);
			actor.getSprite("head").setBrush("bust_skeleton_head_0" + pp);
			actor.getSprite("hair").setBrush(hair_type_zombie);
			this.getContainer().getActor().getSprite("body").setBrush("bust_skeleton_body_0" + pp);
			pp = this.Math.rand(1, 1.7);
			actor.getSprite("head").Saturation = pp;
			actor.getSprite("body").Saturation = pp;
		}
		else
		{
			actor.getSprite("head").setBrush("bust_skeleton_head_05");
			actor.getSprite("hair").setBrush("hair_" + hair_color + "_" + hair_type);
			pp = this.Math.rand(0, 3);
			if (pp == 0)
			{
				actor.getSprite("beard").setBrush("");
				actor.getSprite("beard_top").setBrush("");
			}
			else
			if (pp == 1)
			{
				actor.getSprite("beard").setBrush("beard_" + hair_color + "_08");
				actor.getSprite("beard_top").setBrush("");
			}
			else
			{
				actor.getSprite("beard").setBrush("beard_" + hair_color + "_" + beard_type);
				actor.getSprite("beard_top").setBrush(actor.getSprite("beard").getBrush().Name + "_top");
			}
			actor.getSprite("beard").setBrush("beard_" + hair_color + "_" + beard_type);
			actor.getSprite("beard_top").setBrush(actor.getSprite("beard").getBrush().Name + "_top");
			this.getContainer().getActor().getSprite("body").setBrush("bust_skeleton_body_05");
			pp = this.Math.rand(1, 2.5);
			actor.getSprite("head").Saturation = pp;
			actor.getSprite("body").Saturation = pp;
		}
		pp = this.Math.rand(0, 1);
		if (pp == 0)
		{
			actor.getSprite("tattoo_body").setBrush("bust_skeleton_detail_03");
			actor.getSprite("tattoo_head").setBrush("bust_skeleton_head_detail_01");
		}
		else
		{
			actor.getSprite("tattoo_body").setBrush("bust_skeleton_detail_02");
		}
	  }
	}

	function onAdded()
	{
		this.xxhero_background.onAdded();
		if (!this.getContainer().getActor().getSkills().hasSkill("effects.xxzzvoice_skill"))
		{
			local actor = this.getContainer().getActor();
			actor.getSkills().add(this.new("scripts/skills/actives/xxzzvoice_skill"));
			actor.getFlags().add("xxzzvoice_undead");
		}
	}

});

