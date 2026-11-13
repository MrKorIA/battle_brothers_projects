this.falconer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_falconer";
		this.m.Name = "Сокольничий";
		this.m.Icon = "ui/backgrounds/background_falconer.png";
		this.m.BackgroundDescription = "Сокольничие в совершенстве владеют древним искусством соколиной охоты и дрессировки пернатых хищников.";
		this.m.GoodEnding = "Пока отряд \'%companyname%\' продолжал преуспевать, %name% решил оставить наёмничество позади. Он вернулся в леса и основал питомник для обучения соколов. В целом, опыт наёмника не изменил его характер - %name% и его соколы легко перешли от охоты на людей обратно к охоте на зверей.";
		this.m.BadEnding = "Видя явный упадок \'%companyname%\', %name% покинул отряд и вернулся к соколиной охоте. К несчастью, у него настали трудные времена, и он был вынужден продать своих драгоценных птиц, чтобы свести концы с концами. По последним слухам, это решение свело его с ума, и он ушёл в лес, где его больше никто не видел.";
		this.m.HiringCost = 50;
		this.m.DailyCost = 14;
		this.m.Excluded = [
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.dumb",
			"trait.short_sighted",
			"trait.clumsy",
			"trait.gluttonous",
			"trait.craven",
			"trait.dastard",
		];
		this.m.Titles = [
			"Сокольничий",
			"Птичий мастер",
			"Сокольничий",
			"Лесник",
			"Орлиный глаз",
			"Главный разведчик",
			"Наблюдатель"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Может выпускать соколов без затрат ОД"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Соколы, выпущенные сокольничим, открывают территорию на 16 клеток вместо 12"
			}
		];
	}

	function onBuildDescription()
	{
        return "{%name% всегда питал увлечение пернатыми созданиями. Тогда он и не подозревал, что однажды это увлечение станет его нишей на поле боя. | %name% был сыном искусного охотника. Хотя сам он не унаследовал отцовской меткости с луком, умение обращаться с птицами сделало его незаменимым спутником на охоте. | В юности %name% любил бродить по лесам. Однажды он наткнулся на раненого сокола и выходил его. С тех пор %name% стал настоящим мастером в обращении с пернатыми.} {Со временем сокольничий понял, что его умение высматривать зверя в лесной чаще с тем же успехом применимо и к разведке вражеских построений. | Когда из-за ошибочно названной им цели стрела угодила в шею его товарищу-леснику, он понял: с прежним ремеслом покончено. | К несчастью, неудачный охотничий сезон вынудил укротителя птиц искать иные источники дохода. | Война выгнала дичь из лесов, а вместе с ней - и его самого. Теперь он ищет для себя другое занятие.} {Такому меткому глазу, как у этого человека, найдётся применение в любом отряде. | Несмотря на скромное происхождение, %name% уже успел показать себя незаменимым разведчиком не в одной войне за интересы знати. | %name% несёт на плече своего сокола, восседающего там величественно, точно на троне, - и с первого взгляда ясно, что хозяин и птица давно стали единым целым. | %name% выглядит так, будто ему есть что доказать - его острый взгляд и ловкие движения ещё пригодятся на поле боя. | У сокола на его плече стальной, немигающий взгляд - вы подозреваете, что эта птица повидала с высоты куда больше сражений, чем иной начинающий наёмник.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [-3, -3]
			Bravery = [0, 0]
			Stamina = [0, 0]
			MeleeSkill = [0, 0]
			RangedSkill = [8, 10]
			MeleeDefense = [-5, 0]
			RangedDefense = [4, 4]
			Initiative = [14, 20]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/short_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		items.equip(this.new("scripts/items/accessory/falcon_item"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});

