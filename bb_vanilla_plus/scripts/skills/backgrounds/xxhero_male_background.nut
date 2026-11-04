this.xxhero_male_background <- this.inherit("scripts/skills/backgrounds/xxhero_background", {
	m = {
		Mantype = 1
	},
	function create()
	{
		this.xxhero_background.create();
		this.m.Mantype = this.Math.rand(0, 10);
	  if (this.m.Mantype == 1) // druid
	  {
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 100;
		this.m.Names = this.Const.Strings.BarbarianNames;
	  }
	  else if (this.m.Mantype == 2) // demonslayer
	  {
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.Military;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
	  }
	  else if (this.m.Mantype == 3) // jotun
	  {
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.BeardChance = 100;
		this.m.Names = this.Const.Strings.BarbarianNames;
	  }
	  else if (this.m.Mantype == 4) // necro
	  {
		this.m.Faces = this.Const.Faces.Necromancer;
		this.m.Hairs = this.Const.Hair.Necromancer;
		this.m.HairColors = this.Const.HairColors.Zombie;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 70;
	  }
	  else if (this.m.Mantype == 5) // shaman
	  {
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.Zombie;
		this.m.Beards = this.Const.Beards.SouthernOnly;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.BarbarianNames;
	  }
	  else if (this.m.Mantype == 6) // maskman
	  {
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.BeardChance = 0;
	  }
	  else if (this.m.Mantype == 7) // wulin
	  {
		this.m.Names = [
            "Юэ Фэй",
			"Юань Шао",
			"Ли Гуан",
			"Хань Синь",
			"Сян Юй",
			"И Шинь",
			"У Ци",
			"Сунь У",
			"Сунь Цюань",
			"Чжоу Юй",
			"Тайши Цы",
			"Гань Нин",
			"Дун Чжо",
			"Люй Бу",
			"Цао Цао",
			"Дянь Вэй",
			"Сюй Чу",
			"Сяхоу Дунь",
			"Цзя Сюй",
			"Го Цзя",
			"Сыма И",
			"Лю Бэй",
			"Гуань Юй",
			"Чжан Фэй",
			"Чжугэ Лян",
			"Ма Чао",
			"Ван Ци",
			"Чэнь"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.Zombie;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
	  }
	  else if (this.m.Mantype == 8) // dwarf
	  {
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.BeardChance = 100;
	  }
	  else
	  {
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.BeardChance = 50;
	  }
	}

	function onSetAppearance()
	{
	  if (this.m.Mantype == 1) // druid
	  {
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local hair_color = [
			"blonde",
			"brown",
			"red"
		];
		hair_color = hair_color[this.Math.rand(0, hair_color.len() - 1)]
		local hair_type = [
			"03",
			"08",
			"18",
			"21"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
		local beard_type = [
			"12",
			"13",
			"14",
			"15",
			"17"
		];
		beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)]

		tattoo_body.setBrush("tattoo_04_" + actor.getSprite("body").getBrush().Name);
		tattoo_body.Visible = true;
		tattoo_head.setBrush("warpaint_02_head");
		tattoo_head.Visible = true;
		actor.getSprite("permanent_injury_4").setBrush("hair_black_zombie_04");
		actor.getSprite("permanent_injury_4").Visible = true;
		actor.getSprite("hair").setBrush("hair_" + hair_color + "_" + hair_type);
		actor.getSprite("beard").setBrush("beard_" + hair_color + "_" + beard_type);
		actor.getSprite("beard_top").setBrush(actor.getSprite("beard").getBrush().Name + "_top");
		actor.getSprite("hair").Color = this.createColor("#61b06d");
		actor.getSprite("beard").Color = this.createColor("#61b06d");
		actor.getSprite("beard_top").Color = this.createColor("#61b06d");
	  }
	  else if (this.m.Mantype == 2) // demonslayer
	  {
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local xbody = actor.getSprite("body");
		xbody.Saturation = 0.2;
		xhead.Saturation = xbody.Saturation;
		if (this.Math.rand(0, 1) == 1)
		{
			actor.getSprite("tattoo_head").setBrush("warpaint_02_head");
			actor.getSprite("tattoo_body").setBrush("tattoo_0" + this.Math.rand(6, 6) + "_" + actor.getSprite("body").getBrush().Name);
			actor.getSprite("tattoo_head").Saturation = 2.5;
			actor.getSprite("tattoo_body").Saturation = 2;
		}
		else
		{
			if (this.Math.rand(0, 1) == 1)
			{
				actor.getSprite("tattoo_head").setBrush("tattoo_01_head");
			}
			else
			{
				actor.getSprite("tattoo_head").setBrush("bust_skeleton_head_detail_01");
			}
			actor.getSprite("tattoo_body").setBrush("tattoo_03_" + actor.getSprite("body").getBrush().Name);
			actor.getSprite("tattoo_head").Saturation = 5.5;
			actor.getSprite("tattoo_body").Saturation = 3.5;
		}
		actor.getSprite("tattoo_head").Visible = true;
		actor.getSprite("tattoo_head").Color = this.createColor("#8cff00");
		actor.getSprite("tattoo_body").Visible = true;
		actor.getSprite("tattoo_body").Color = this.createColor("#8cff00");
		actor.getSprite("permanent_injury_4").setBrush("zombie_rage_eyes");
		actor.getSprite("permanent_injury_4").Visible = true;
		actor.getSprite("permanent_injury_4").Color = this.createColor("#1aff00");
		actor.getSprite("permanent_injury_4").Saturation = 0.7;
	  }
	  else if (this.m.Mantype == 3) // jotun
	  {
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local xbody = actor.getSprite("body");
		local xhair = actor.getSprite("hair");
		local xbeard = actor.getSprite("beard");
		local xbeard_top = actor.getSprite("beard_top");
		local tattoo_body = actor.getSprite("tattoo_body");
		local hair_type = [
			"southern_03",
			"southern_03",
			"southern_03",
			"03",
			"18",
			"21"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)];
		local beard_type = [
			"southern_01",
			"southern_02"
		];
		beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)];
		local pp;

		actor.getSprite("hair").setBrush("hair_grey_" + hair_type);
		pp = this.Math.rand(1, 3);
		if (pp == 1)
		{
			actor.getSprite("beard").setBrush("beard_grey_" + beard_type);
			actor.getSprite("beard_top").setBrush(actor.getSprite("beard").getBrush().Name + "_top");
		}
		tattoo_body.setBrush("tattoo_0" + this.Math.rand(2, 4) + "_" + actor.getSprite("body").getBrush().Name);
		tattoo_body.Visible = true;
		if (this.Math.rand(0, 1) != 1)
		{
			xhead.Color = this.createColor("#73a6ff");
			xhead.setBrightness(1.1);
			xbody.setBrightness(1.1);
		}
		else
		{
			xhead.Color = this.createColor("#669eff");
		}
		xbody.Color = xhead.Color;
		xhair.Color = this.createColor("#faffff");
		xbeard.Color = xhair.Color;
		xbeard_top.Color = xhair.Color;
		xhead.Saturation = 0.9;
		xbody.Saturation = xhead.Saturation;
		xhair.Saturation = 2.0;
		xbeard.Saturation = xhair.Saturation;
		xbeard_top.Saturation = xhair.Saturation;
	  }
	  else if (this.m.Mantype == 4) // necro
	  {
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local xbody = actor.getSprite("body");
		local xtattoo_head = actor.getSprite("tattoo_head");
		xbody.Saturation = 0.4;
		xhead.Saturation = xbody.Saturation;
		if (this.Math.rand(0, 1) == 1)
		{
			if (this.Math.rand(0, 1) == 0)
			{
				xtattoo_head.setBrush("bust_head_pox_01");
			}
			else
			{
				xtattoo_head.setBrush("bust_head_darkeyes_01");
			}
		}
	  }
	  else if (this.m.Mantype == 5) // shaman
	  {
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local xbody = actor.getSprite("body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local tattoo_body = actor.getSprite("tattoo_body");
		local hair_color = this.Const.HairColors.Zombie[this.Math.rand(0, 1)]
		local pp = this.Math.rand(1, 2)
		if (pp == 1)
		{
			xhead.setBrush(this.Const.Faces.SouthernMale[this.Math.rand(0, this.Const.Faces.SouthernMale.len() - 1)]);
			xbody.setBrush(this.Const.Bodies.SouthernSkinny[this.Math.rand(0, this.Const.Bodies.SouthernSkinny.len() - 1)]);
			xhead.Color = this.createColor("#999491");
			xhead.Saturation = 0.4;
		}
		else
		{
			xhead.Color = this.createColor("#995c31");
			xhead.Saturation = 0.8;
		}
		xbody.Color = xhead.Color;
		xbody.Saturation = xhead.Saturation;

		pp = this.Math.rand(1, 3);
		if (pp == 1)
		{
			tattoo_body.setBrush("tattoo_0" + this.Math.rand(4, 4) + "_" + actor.getSprite("body").getBrush().Name);
			tattoo_head.setBrush("tattoo_0" + this.Math.rand(4, 5) + "_head");
		}
		else
		if (pp == 2)
		{
			tattoo_body.setBrush("warpaint_01_" + actor.getSprite("body").getBrush().Name);
			tattoo_head.setBrush("warpaint_01_head");
		}
		else
		{
			tattoo_body.setBrush("scar_0" + this.Math.rand(2, 2) + "_" + actor.getSprite("body").getBrush().Name);
			tattoo_head.setBrush("scar_02_head");
		}
		tattoo_body.Visible = true;
		tattoo_head.Visible = true;

		pp = this.Math.rand(1, 2);
		if (pp == 1)
		{
			actor.getSprite("hair").setBrush("hair_" + hair_color + "_" + this.Const.Hair.SouthernMaleOnly[this.Math.rand(4, 4)]);
		}
		pp = this.Math.rand(0, 2);
		if (pp == 0)
		{
			actor.getSprite("beard").setBrush("beard_" + hair_color + "_" + this.Const.Beards.SouthernOnly[this.Math.rand(0, 1)]);
			actor.getSprite("beard_top").setBrush(actor.getSprite("beard").getBrush().Name + "_top");
		}
	  }
	  else if (this.m.Mantype == 6) // maskman
	  {
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local hair_type = [
			"01",
			"02",
			"04",
			"06",
			"07",
			"10",
			"13",
			"14",
			"15",
			"19",
			"20",
			"21",
			"southern_03"
		];
		xhead.setBrush("bust_head_787" + this.Math.rand(4, 5));
		actor.getSprite("hair").setBrush("hair_" + this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)] + "_" + hair_type[this.Math.rand(0, hair_type.len() - 1)]);
	  }
	  else if (this.m.Mantype == 7) // wulin
	  {
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local xbody = actor.getSprite("body");
		local hair_type = [
			"hair_black_8010",
			"hair_black_8011",
			"hair_black_8012",
			"hair_black_8013",
			"hair_black_19"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
		local beard_type = [
			"xxbeard_black_1000",
			"beard_black_05",
			"beard_black_06"
			"beard_black_07",
			"beard_black_08",
			"beard_black_09"
		];
		beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)]
		local pp = this.Math.rand(1, 3);
		if (pp != 1)
		{
			actor.getSprite("beard").setBrush(beard_type);
		}
		actor.getSprite("hair").setBrush(hair_type);
		xhead.Color = this.createColor("#d6b074");
		xbody.Color = xhead.Color;
	  }
	  else if (this.m.Mantype == 8) // dwarf
	  {
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		actor.getSprite("hair").setBrush("hair_beast_0" + this.Math.rand(1, 3));
		local pp = this.Math.rand(1, 3);
		if (pp == 1)
		{
			tattoo_body.setBrush("tattoo_0" + this.Math.rand(2, 4) + "_bust_naked_body_02");
			tattoo_head.setBrush("tattoo_01_head");
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		else if (pp == 2)
		{
			tattoo_body.setBrush("warpaint_01_bust_naked_body_02");
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		if (this.Math.rand(1, 3) == 2)
		{
			actor.getSprite("beard").setBrush("beard_brown_08");
			actor.getSprite("beard_top").setBrush("");
		}
	  }
	  else
	  {
		local actor = this.getContainer().getActor();
		local tattoo_head = actor.getSprite("tattoo_head");
		local tattoo_body = actor.getSprite("tattoo_body");
		tattoo_head.setBrush("scar_0" + this.Math.rand(2, 2) + "_head");
		tattoo_head.Visible = true;
		tattoo_body.setBrush("scar_0" + this.Math.rand(1, 2) + "_" + actor.getSprite("body").getBrush().Name);
		tattoo_body.Visible = true;
		if (this.Math.rand(0, 2) == 2)
		{
			actor.getSprite("head").setBrush("bust_head_" + this.Math.rand(10, 20));
		}
	  }
	}

});

