this.champion_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_champion";
		this.m.Name = "Чемпион";
		this.m.Icon = "ui/backgrounds/background_champion.png";
		this.m.BackgroundDescription = "Чемпионы - это рыцари, заслужившие бессмертную славу в дуэльных поединках. Столь именитые воители обычно служат благородным домам и крайне редко опускаются до наёмнического ремесла.";
        this.m.GoodEnding = "Покинув отряд \'%companyname%\', %name% так и не нашёл себе равного, и, как выяснилось, в этом была его главная беда. Вы слышали, что он ходит от одной войны к другой и не проиграл ещё ни разу, но победы давно не приносят ему радости. Каждый, кто хочет прославиться, сперва приходит бросить ему вызов, так что скучать ему не приходится. Говорят, при этом он всякий раз тайно надеется, что нынешний противник окажется лучше.";
        this.m.BadEnding = "Покинув отряд \'%companyname%\', %name% решил, что обычные сражения больше не способны его удивить, и отправился искать настоящего противника. Из письма, дошедшего до вас через третьи руки, следовало, что нашёл он его в придорожной таверне: тихого путника, не пожелавшего назвать своё имя. Поединок продлился ровно один удар. Непобедимый чемпион получил наконец то, чего так долго искал, - настоящий бой, о котором теперь некому рассказать.";
		this.m.HiringCost = 4000;
		this.m.DailyCost = 45;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.bright",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.drunkard",
			"trait.dumb",
			"trait.fainthearted",
			"trait.fat",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.gluttonous",
			"trait.hesitant",
			"trait.insecure",
			"trait.paranoid",
			"trait.pessimist",
			"trait.quick",
			"trait.tiny",
			"trait.weasel"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Initiative,
			this.Const.Attributes.RangedSkill,
			this.Const.Attributes.RangedDefense
		];
		this.m.Titles = [
			"Легендарный",
			"Могучий",
			"Непобедимый",
			"Непобежденный",
			"Фаворит",
			"Чемпион",
			"Уверенный",
			"Гора",
			"Крепыш",
			"Несокрушимый",
			"Убийца рыцарей"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsCombatBackground = true;
		this.m.Level = 6;
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
			}
		];
	}

	function onBuildDescription()
	{
        return "{Некоторые говорят, что есть лишь два типа людей: те, кто не знает поражений и чьи деяния неизбежно становятся легендами, и все прочие, совершенно незначительные слюнтяи. Правдива эта поговорка или нет, но %name% одним своим видом ясно даёт понять, к какому из этих двух типов он относится. | Одни рождены побеждать, другие - лишь наблюдать за победителями со стороны. %name%, судя по его выправке и уверенному взгляду, явно принадлежит к первым. | Легенды не рождаются из ничего - для этого нужен человек, который просто не умеет проигрывать. %name%, похоже, именно такой человек. | Достаточно взглянуть, как %name% держится и как на него смотрят окружающие, чтобы понять: этот человек привык побеждать, а не участвовать.} {Несмотря на относительную молодость, %name% уже несколько лет проработал инструктором по боевой подготовке в местном тренировочном зале. Почему он решил присоединиться к отряду наёмников именно сейчас - остаётся загадкой. | %name% уже который год не знает поражений на местной арене, где бьётся на потеху зрителям - но недавно он вдруг заявил, что устал от постановочных схваток. | В юности %name% выиграл столько турниров подряд, что организаторы попросту перестали его приглашать - победа была предрешена заранее, а зрителям это наскучило. | %name% много лет служил капитаном городской стражи, ни разу не проиграв ни одного поединка чести - но отчего-то решил, что настало время сменить род занятий. | %name% с юных лет считался лучшим бойцом гарнизона, и его поединки неизменно заканчивались одним и тем же результатом - но по неведомой причине он захотел большего.} {Вы смотрите на запрошенное им жалование и едва сдерживаетесь, чтобы не рассмеяться в голос. Но всё, что говорит %name% в ответ - что он готов согласиться и на меньшую сумму, лишь бы снова испытать нечто похожее на настоящее приключение. | Названная им сумма заставляет вас невольно поднять бровь - но он тут же добавляет, что ради глотка настоящих приключений готов уступить в цене. | Услышав, сколько он просит, вы едва удерживаетесь от смешка - однако он спокойно поясняет, что жалование для него сейчас куда менее важно, чем возможность вновь почувствовать азарт боя. | Цифра, которую он называет, откровенно велика - но, заметив ваше замешательство, он тут же смягчается: приключения для него дороже золота.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 25)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [12, 18]
			Bravery = [10, 10]
			Stamina = [10, 12]
			MeleeSkill = [14, 14]
			RangedSkill = [0, 0]
			MeleeDefense = [8, 8]
			RangedDefense = [4, 4]
			Initiative = [-18, -10]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.HedgeKnightTitles[this.Math.rand(0, this.Const.Strings.HedgeKnightTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_flanged_mace"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/greatsword"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_flanged_mace"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_flanged_mace"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/greatsword"));
			}
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/scale_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/reinforced_mail_hauberk"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/bascinet_with_mail"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/closed_flat_top_helmet"));
		}
	}

});

