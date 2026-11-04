this.blacksmith_crafts_masterwork_armor_event <- this.inherit("scripts/events/event", {
	m = {
		Blacksmith = null,
		OtherBro1 = null,
		OtherBro2 = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_blacksmith_crafts_masterwork_armor";
		this.m.Title = "Рядом с городом...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] Неподалеку от города %townname%, пока вы заняты подсчётом жалованья для отряда, к вам уверенным шагом направляется %blacksmith%. В глазах кузнеца горит лихорадочный огонь. Он крепко сжимает в руке свой верный молот и без лишних предисловий заводит разговор.\n\nОн признаётся, что этой ночью ему явился вещий сон: благородные рыцари в сияющих, непробиваемых латах яростно рубили полчища ходячих мертвецов. Прежде чем вы успеваете оборвать его фразой в духе \'Да кому какое дело до твоих снов\', кузнец поднимает свой молот и заворожённо устремляет на него взор.\n\nПо его глубокому убеждению, местный город %townname% и его раскалённые горны - это идеальное место, чтобы воплотить в металле тот самый доспех, который явился ему в ночных грёзах. На закупку редких материалов и аренду лучших плавилен он просит ни много ни мало шесть тысяч крон.\n\nВы прищуриваетесь, пытаясь разгадать истинные мысли ремесленника. Шесть тысяч монет - это огромная сумма, которой хватило бы на недели безбедной жизни для всего отряда. Однако суровый и фанатичный взгляд мастера не оставляет сомнений: он не просто настроен серьёзно, он свято верит, что этот шедевр кузнечного дела превзойдёт любые ожидания.\n\nИнтуиция подсказывает вам: если упустить этот шанс сейчас, подобные обстоятельства уже вряд ли когда-нибудь повторятся.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Создай доспех, достойный героя!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Сейчас у нас нет на это денег.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Blacksmith.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] %blacksmith% в конце концов возвращается в лагерь отряда. Кузнец бережно несёт результат своих трудов, аккуратно завёрнутый в тонкую ткань, и почтительно укладывает свёрток прямо на ваш походный стол. Вы не торопясь развязываете узлы, желая воочию увидеть, на что именно ушло целое состояние в шесть тысяч крон.\n\nНа миг вам чудится, будто мастер потерпел неудачу и просто возвращает мешки со слитками назад, однако по мере того, как из-под плотного сукна проступает кованый нагрудник, у вас перехватывает дыхание от неописуемого великолепия этой работы.\n\nКажется, металл сам по себе излучает мягкое сияние, разгоняя полумрак лагерной палатки. Сдерживая священный трепет, вы от души поздравляете оружейника с потрясающим успехом. Этот доспех непременно спасёт жизнь кому-то из ваших людей в грядущих битвах и прославят имя отряда на все обитаемые земли!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Какое превосходное мастерство!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Blacksmith.getImagePath());
				this.World.Assets.addMoney(-6000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы тратите [color=" + this.Const.UI.Color.NegativeEventValue + "]6.000[/color] крон"
				});
				local item = this.new("scripts/items/armor/named/golden_scale_armor");
				item.m.Name = "Доспех героев высшего качества: мастер " + _event.m.Blacksmith.getNameOnly();
				item.m.Description = "Сверкающий кованый нагрудник, ослепительно переливающийся в лучах солнца. Мастерство создания лат подобного качества веками считалось безвозвратно утраченным искусством, но этот доспех доказывает обратное. Он ощущается намного легче, чем кажется на первый взгляд, но при этом обеспечивает феноменальную защиту. Истинный венец творения великого мастера!";
				item.m.StaminaModifier = -14;
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				_event.m.Blacksmith.improveMood(2.0, "Создал доспехи, достойные героев");

				if (_event.m.Blacksmith.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Blacksmith.getMoodState()],
						text = _event.m.Blacksmith.getName() + this.Const.MoodStateEvent[_event.m.Blacksmith.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 12500)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && (t.isMilitary() || t.isSouthern()))
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 8
				&& bro.getBackground().getID() == "background.hackflows_blacksmith")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Blacksmith = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 2000;
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Blacksmith.getID())
			{
				this.m.OtherBro1 = bro;
				break;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Blacksmith.getID() && bro.getID() != this.m.OtherBro1.getID())
			{
				this.m.OtherBro2 = bro;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"blacksmith",
			this.m.Blacksmith.getNameOnly()
		]);
		_vars.push([
			"otherbro1",
			this.m.OtherBro1.getName()
		]);
		_vars.push([
			"otherbro2",
			this.m.OtherBro2.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Blacksmith = null;
		this.m.OtherBro1 = null;
		this.m.OtherBro2 = null;
		this.m.Town = null;
	}

});

