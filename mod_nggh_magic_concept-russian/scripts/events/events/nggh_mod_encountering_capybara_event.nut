this.nggh_mod_encountering_capybara_event <- ::inherit("scripts/events/event", {
	m = {
		Finder = null
		Bystander = null,
	},
	function create()
	{
		this.m.ID = "event.encountering_capybara";
		this.m.Title = "На привале...";
		this.m.Cooldown = 45.0 * ::World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{%finder%, отошедший отлить, замечает капибару, внимательно следящую за грохочущим водопадом, обильно опустошающим небольшой куст у ног наёмника.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Погладить её.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Помочиться на неё.",
					function getResult( _event )
					{
						return "C";
					}
				},
				{
					Text = "Не обращать на неё внимания.",
					function getResult( _event )
					{
						_event.m.Finder.improveMood(2.0, "Да! Я извращенец");
						return 0;
					}
				},
				{
					Text = "Отнести её в лагерь.",
					function getResult( _event )
					{
						return "D";
					}
				},
				{
					Text = "Убежать в страхе.",
					function getResult( _event )
					{
						return "E";
					}
				}
			],
			function start( _event )
			{
				this.Banner = "ui/icons/capybara.png";
				this.Characters.push(_event.m.Finder.getImagePath());
				local post_text = "";

				switch (::Math.rand(1, 3))
				{
				case 1:
					_event.m.Finder.improveMood(0.1, "Смущен наблюдением за опорожнением мочевого пузыря");
					post_text = " смущён";
					break;

				case 2:
					_event.m.Finder.improveMood(1.0, "Плавал обнажённым перед капибарой");
					post_text = " чувствует необычное воодушевление";
					break;
			
				default:
					_event.m.Finder.worsenMood(0.5, "Почему капибара смотрит столь пристально?");
					post_text = " разочарован произошедшим";
				}
				
				this.List.extend([
					{
						id = 10,
						icon = "ui/icons/asset_brothers.png",
						text = _event.m.Finder.getName() + post_text
					},
					{
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Finder.getMoodState()],
						text = _event.m.Finder.getName() + ::Const.MoodStateEvent[_event.m.Finder.getMoodState()]
					}
				]);
			}
		});


		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{%finder% гладит извращенную капибару. Похоже, ей нравится, когда ее гладят по голове}.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Какой непослушный мальчик.",
					function getResult( _event )
					{
						return 0;
					}
				},
			],
			function start( _event )
			{
				this.Banner = "ui/icons/capybara.png";
				this.Characters.push(_event.m.Finder.getImagePath());
				_event.m.Finder.improveMood(1.0, "Хочет капибару в качестве питомца");
				
				this.List.extend([
					{
						id = 10,
						icon = "ui/icons/asset_brothers.png",
						text = _event.m.Finder.getName() + " пал под очарованием капибары"
					},
					{
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Finder.getMoodState()],
						text = _event.m.Finder.getName() + ::Const.MoodStateEvent[_event.m.Finder.getMoodState()]
					}
				]);
			}
		});


		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{%finder% мочится на капибару, но она, похоже, не возражает против этого.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Почему я решил, что это будет хорошей идеей?",
					function getResult( _event )
					{
						return 0;
					}
				},
			],
			function start( _event )
			{
				this.Banner = "ui/icons/capybara.png";
				this.Characters.push(_event.m.Finder.getImagePath());
				local post_text = "";

				if (::Math.rand(1, 100) <= 50)
				{
					this.Text += " %finder% начинает сомневаться в собственном здравомыслии}.";
					post_text = " удивлён";
					_event.m.Finder.worsenMood(1.0, "Я сделал кое-что очень очень очень очень странное");
				}
				else
				{
					this.Characters.push(_event.m.Bystander.getImagePath());
					this.Text += "Вдруг откуда ни возьмись появляется %bystander%. На %bystander% смотрит пьяный и удивленный взгляд, а %bystander% смотрит на 'дело', которым занимается %finder%. Двое смотрят друг на друга некоторое время, на заднем плане слышится плеск воды. Наблюдатель% ничего не говорит, разворачивается и уходит, оставляя %finder% с мокрой капибарой.}" 
					post_text = " не в силах поднять взгляд на " + _event.m.Bystander.getNameOnly() + "";
					_event.m.Finder.worsenMood(2.0, "Глубоко смущен 'определенным' событием");
					_event.m.Bystander.worsenMood(0.5, "Увидел немыслимое");

					this.List.extend([
						{
							id = 10,
							icon = "ui/icons/asset_brothers.png",
							text = _event.m.Bystander.getName() + " обеспокоен увиденным"
						},
						{
							id = 10,
							icon = "ui/icons/relations.png",
							text = _event.m.Bystander.getName() + " сильно разочаровался в брате по имени " + _event.m.Finder.getName() + ""
						},
					]);

					if (_event.m.Bystander.getMoodState() < ::Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = ::Const.MoodStateIcon[_event.m.Bystander.getMoodState()],
							text = _event.m.Bystander.getName() + ::Const.MoodStateEvent[_event.m.Bystander.getMoodState()]
						});
					}
				}
				
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_brothers.png",
					text = _event.m.Finder.getName() + post_text
				});

				if (_event.m.Finder.getMoodState() < ::Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Finder.getMoodState()],
						text = _event.m.Finder.getName() + ::Const.MoodStateEvent[_event.m.Finder.getMoodState()]
					});
				}
			}
		});


		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{%finder% идет прямо на капибару, но та не обращает на него никакого внимания. %finder% пытается схватить гигантского грызуна, но сталкивается с ожесточённым сопротивлением. Капибара прыгает и бьёт головой, попадая прямо в питон брата. %finder% кричит в агонии, а грызун убегает в поисках своих друзей.\n\nУрок усвоен, никогда не пытайтесь похитить капибару, наблюдающую за тем, как кто-то мочится.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мой питон!",
					function getResult( _event )
					{
						return 0;
					}
				},
			],
			function start( _event )
			{
				this.Banner = "ui/icons/capybara.png";
				this.Characters.push(_event.m.Finder.getImagePath());
				_event.m.Finder.improveMood(2.0, "Сломал своего 'питона' из-за некоторых событий");
				
				this.List.extend([
					{
						id = 10,
						icon = "ui/icons/asset_brothers.png",
						text = _event.m.Finder.getName() + " исписан жизнью"
					},
					{
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Finder.getMoodState()],
						text = _event.m.Finder.getName() + ::Const.MoodStateEvent[_event.m.Finder.getMoodState()]
					}
				]);
			}
		});


		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%finder% сломя голову бежит, не оглядываясь и крича как девчонка}.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "!!!",
					function getResult( _event )
					{
						return 0;
					}
				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Finder.getImagePath());

				local effect = ::new("scripts/skills/effects_world/afraid_effect");
				_event.m.Finder.getSkills().add(effect);
				_event.m.Finder.worsenMood(1.0, "Увидел дурное предзнаменование");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Finder.getName() + " напуган"
				});

				if (_event.m.Finder.getMoodState() < ::Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Finder.getMoodState()],
						text = _event.m.Finder.getName() + ::Const.MoodStateEvent[_event.m.Finder.getMoodState()]
					});
				}
			}
		});
	}

	function onUpdateScore()
	{
		if (::World.getPlayerRoster().getAll().len() <= 2)
			return;

		this.m.Score = ::World.Flags.get("IsLuftAdventure") ? ::Math.rand(15, 35) : ::Math.rand(10, 20);
	}

	function onPrepare()
	{
		local priority = [];
		local betterThanNothing = [];
		local brothers = ::World.getPlayerRoster().getAll();

		foreach ( bro in brothers )
		{
			if ((bro.getFlags().has("luft") || bro.getFlags().has("IsPlayerCharacter")) && ::Math.rand(1, 100) <= 15)
				priority.push(bro);
			else
				betterThanNothing.push(bro);
		}

		if (priority.len() > 0)
		{
			this.m.Finder = priority[0];
		}
		else
		{
			this.m.Finder = ::MSU.Array.rand(betterThanNothing);
		}

		while(this.m.Bystander == null)
		{
			local roll = ::MSU.Array.rand(brothers);

			if (roll.getID() != this.m.Finder.getID())
			{
				this.m.Bystander = roll;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"finder",
			this.m.Finder.getName()
		]);
		_vars.push([
			"bystander",
			this.m.Bystander.getName()
		]);
	}

	function onClear()
	{
		this.m.Finder = null;
		this.m.Bystander = null;
	}

});

