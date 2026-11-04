this.cultist_requests_nose_removal_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Surgeon = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_cultist_requests_nose_removal";
		this.m.Title = "В минуту затишья...";
		this.m.Cooldown = 15.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img][M] Во время походного марша из строя одновременно выходят двое: %surgeon% уверенно шагает к вам, а следом за ним плетётся %cultist%. Вы недоумённо вскидываете бровь и ждёте, пока кто-нибудь из них прервёт молчание. Однако безумец лишь уставился на вас своим привычным пустым, мертвенным взором. Заметив это, %surgeon% раздражённо вздыхает и заговаривает первым.%SPEECH_ON%Это просто уму непостижимо, капитан! Буквально мгновение назад этот проклятый фанатик без умолку бредил о каком-то \'Великом Давкуле\' или вроде того. А теперь этот полоумный требует, чтобы я немедленно отрезал ему нос!%SPEECH_OFF%Лекарь с глубоким недоверием качает головой, переводя взгляд с вас на фанатика.%SPEECH_ON%По правде говоря, капитан, в медицинских трактатах я читал о подобных увечьях... И если этот болван так отчаянно жаждет лишиться куска плоти на лице, мой скальпель к его услугам. Но раз уж вы здесь главный, последнее слово я предоставлю вам. Только учтите: за столь грязную работёнку я возьму с вас не меньше двухсот крон. Я, чёрт меня дери, на подобное безумие при найме не подписывался!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Сделай, как он просит. Я позабочусь, чтобы ты получил плату.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Это безумие. Мы режем врагов, а не своих братьев!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Surgeon.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_03.png[/img][M] Вы одобрительно киваете, и %surgeon% в ответ лишь мрачно ухмыляется, предвкушая звон монет.%SPEECH_ON%Кроны есть кроны, капитан. Мой скальпель готов.%SPEECH_OFF%Лекарь достает из своей медицинской сумки жуткого вида хирургическую пилу и делает знак культисту следовать за ним. Наш безумец глухо мычит в знак согласия, после чего оба скрываются в уединённой чащобе у края лагеря.\n\nПримерно через полчаса они возвращаются назад. Голову фанатика теперь стягивает плотная повязка, почти полностью скрывающая лицо - наружу смотрит лишь один-единственный глаз. И этот взор устремлён на вас с такой пронзительной, леденящей сосредоточенностью, которая разительно контрастирует с его прежней безумной пустотой. Тем временем %surgeon% молча бредёт позади. Руки лекаря безвольно болтаются вдоль туловища, а сам он отрешённо бормочет под нос.%SPEECH_ON%Давкул ждёт нас всех...%SPEECH_OFF%Культист истово кивает и монотонно вторит ему.%SPEECH_ON%Давкул ждёт нас всех...%SPEECH_OFF%Оба безумца медленно разворачиваются и уходят. Но прежде чем они успевают скрыться из виду, вы с внезапным ужасом замечаете, что на белоснежных бинтах вокруг изрубленной головы фанатика нет ни единого следа крови. Абсолютно чистая ткань. Вы понятия не имеете, какая чертовщина только что разыгралась у вас под носом, но вскоре бесконечные повседневные заботы и хлопоты по командованию отрядом заставляют вас выбросить это из головы.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Похоже, Давкул ждёт нас всех...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Surgeon.getImagePath());
				this.World.Assets.addMoney(-200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы тратите [color=" + this.Const.UI.Color.NegativeEventValue + "]200[/color] крон"
				});
				local injury = _event.m.Cultist.addInjury([
					{
						ID = "injury.missing_nose",
						Threshold = 0.0,
						Script = "injury_permanent/missing_nose_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Cultist.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Surgeon.improveMood(1.0, "Заработал немного крон благодаря своему хирургическому мастерству");

				if (_event.m.Surgeon.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Surgeon.getMoodState()],
						text = _event.m.Surgeon.getName() + this.Const.MoodStateEvent[_event.m.Surgeon.getMoodState()]
					});
				}

				_event.m.Cultist.improveMood(3.0, "Получил помощь брата, чтобы угодить Давкулу");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img][M] Вы решительно качаете головой и, дабы сгладить углы, пытаетесь оправдать свой отказ чересчур высоким хирургическим гонораром. Однако в этот момент %cultist% внезапно устремляет на вас пронзительный, сфокусированный взор. Искажённый рот безумца извергает глухое проклятие.%SPEECH_ON%Давкул запомнит это...%SPEECH_OFF%В ту же секунду на поляне раздаётся омерзительный, тошнотворный хруст кости. Стоящий рядом %surgeon% с диким криком сгибается пополам от невыносимой боли, судорожно закрывая лицо окровавленными руками. Лекарь яростно сквернословит на весь лагерь.%SPEECH_ON%Чёрт бы тебя побрал! Мой нос... этот ублюдок сломал мне нос!%SPEECH_OFF%\n\nОбливающийся кровью %surgeon% поспешно уходит к своей медицинской повозке, чтобы обработать жуткую рану, а довольный %cultist% молча растворяется в лесной чаще, оставляя вас в полном замешательстве и ужасе от произошедшего.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Что, чёрт возьми, только что произошло?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Surgeon.getImagePath());
				local broken_nose_injury = [
					{
						ID = "injury.broken_nose",
						Threshold = 0.25,
						Script = "injury/broken_nose_injury"
					}
				];
				this.injury = _event.m.Surgeon.addInjury(broken_nose_injury);
				this.List = [
					{
						id = 10,
						icon = this.injury.getIcon(),
						text = _event.m.Surgeon.getName() + " suffers " + this.injury.getNameOnly()
					}
				];
				_event.m.Surgeon.worsenMood(2.5, "Получил перелом носа от сверхъестественной силы");

				if (_event.m.Surgeon.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Surgeon.getMoodState()],
						text = _event.m.Surgeon.getName() + this.Const.MoodStateEvent[_event.m.Surgeon.getMoodState()]
					});
				}

				_event.m.Cultist.worsenMood(2.0, "Отказали в просьбе, которая могла бы угодить Давкулу");

				if (_event.m.Cultist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 1500)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_surgeon = [];
		local candidates_cultist = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_surgeon" && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_surgeon.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" && !bro.getSkills().hasSkill("injury.missing_nose"))
			{
				candidates_cultist.push(bro);
			}
		}

		if (candidates_surgeon.len() == 0 || candidates_cultist.len() == 0)
		{
			return;
		}

		this.m.Surgeon = candidates_surgeon[this.Math.rand(0.0, candidates_surgeon.len() - 1)];
		this.m.Cultist = candidates_cultist[this.Math.rand(0.0, candidates_cultist.len() - 1)];
		this.m.Score = 20 * candidates_cultist.len() + 15 * candidates_surgeon.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"surgeon",
			this.m.Surgeon.getName()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Surgeon = null;
	}

});

