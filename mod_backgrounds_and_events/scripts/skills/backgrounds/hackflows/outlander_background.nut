this.outlander_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_outlander";
		this.m.Name = "Чужеземец";
		this.m.Icon = "ui/backgrounds/background_outlander.png";
		this.m.BackgroundDescription = "Чужеземцы прибывают из далёких краёв, до которых месяцы или даже годы опасного морского пути. Их трудно понять в обычной жизни, а уж в бою и подавно.";
        this.m.GoodEnding = "После того, как вы покинули отряд \'%companyname%\', %name% исчез так же бесследно, как когда-то появился. Спустя несколько лет вам довелось встретить торговца из далёких краёв, который, услышав это имя, лишь усмехнулся и сказал, что %name% вернулся домой и теперь владеет там небольшим поместьем. Что именно он делал здесь и почему решил вернуться, торговец объяснить не смог, да вы и не стали спрашивать.";
        this.m.BadEnding = "Однажды после тяжёлого похода %name% просто не вернулся в лагерь. Никто не видел, куда он ушёл, и никто особенно не удивился: человек, о прошлом которого ничего не известно, не оставляет после себя много вопросов. Несколько месяцев спустя в одном из далёких городов вы услышали о чужеземце, которого нашли мёртвым в придорожной канаве. Имени его никто не знал, но при нём нашли монету, которую в этих землях никогда не чеканили.";
		this.m.HiringCost = 30;
		this.m.DailyCost = 24;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.brute",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.cocky",
			"trait.craven",
			"trait.dastard",
			"trait.drunkard",
			"trait.dumb",
			"trait.fainthearted",
			"trait.fat",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.gluttonous",
			"trait.greedy",
			"trait.hate_undead",
			"trait.hesitant",
			"trait.huge",
			"trait.insecure",
			"trait.iron_jaw",
			"trait.tiny",
			"trait.tough"
		];
		this.m.Titles = [
			"Чужак",
			"Чужеземец",
			"Изгой",
			"Незнакомец",
			"Иностранец",
			"Молчаливый",
			"Незнакомый"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Names = [
			"Дмитрий"
			"Александр"
			"Максим"
			"Иван"
			"Владислав"
			"Владимир"
			"Ярослав"
			"Богдан"
			"Мирослав"
			"Михай"
			"Дорин"
			"Иринел"
			"Искандер"
			"Бенджамин"
			"Ной"
			"Сэмюэл"
			"Рафаэль"
			"Жан"
			"Симон"
			"Артур"
			"Тристан"
			"Гастон"
			"Ив"
			"Брайс"
			"Этьен"
			"Луи"
			"Анри"
			"Виктор"
			"Люк"
			"Лео"
			"Марсель"
			"Гай"
			"Алексей"
			"Артём"
			"Игорь"
			"Кирилл"
			"Лев"
			"Михаил"
			"Олег"
			"Ролан"
			"Саша"
			"Василий"
			"Виктор"
			"Юрий"
			"Конор"
			"Лиам"
			"Киллиан"
			"Фионн"
			"Финн"
			"Оуэн"
			"Оскар"
			"Эйдан"
			"Шейн"
			"Кормак"
			"Колм"
			"Лоркан"
		];
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
		this.m.Level = this.Math.rand(2, 3);
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
		return "{%name% и его прошлое окутано тайной. Ясно лишь одно - этот человек определённо не местный. Как и почему он оказался в этой забытой богами дыре, вы не знаете, и у вас есть стойкое чувство, что в ближайшее время не узнаете.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [0, 6]
			Bravery = [0, 10]
			Stamina = [0, 10]
			MeleeSkill = [13, 7]
			RangedSkill = [0, 13]
			MeleeDefense = [0, 3]
			RangedDefense = [0, 3]
			Initiative = [10, 10]
		};
		return c;
	}

	function onAddEquipment()
	{
		// local items = this.getContainer().getActor().getItems();

		// local weapons = ["noble_sword" "arming_sword"], weights = [1 3];
		// if (::Const.DLC.Wildmen) {
		// 	weapons.extend(["shamshir" "scimitar"]);
		// 	weights.extend([1 3]);
		// }
		// Items.setWeapon(items, Rand.choice(weapons, weights))
		// Items.setArmor(items, "noble_mail_armor");

		local items = this.getContainer().getActor().getItems();


		local r;

		if (this.Const.DLC.Wildmen)
		{
			r = this.Math.rand(1, 4);

			if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/shamshir"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/scimitar"));
			}
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/noble_sword"));
		}

		items.equip(this.new("scripts/items/armor/noble_mail_armor"));
	}

});

