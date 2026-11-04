this.arbalester_vs_hunter_event <- this.inherit("scripts/events/event", {
	m = {
		Arbalester = null,
		Hunter = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_arbalester_vs_hunter";
		this.m.Title = "По пути...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img][M] Пока отряд %companyname% движется походным маршем, до вашего слуха доносится жаркий спор. Вы слышите, как %arbalester% арбалетчик говорит: %SPEECH_ON%Я повторяю в последний раз: арбалет - это ультимативное оружие! У него достаточно дури, чтобы пробить тяжелейший доспех и разнести череп рыцарю в самом дорогом шлеме, а не просто пощекотать его! А ваш хвалёный лук хоть и стреляет быстро, но его стрелы против брони - что сосновые иголки!%SPEECH_OFF% Идущий рядом %hunter% презрительно сплёвывает на обочину и тут же парирует: %SPEECH_ON%Пока ты перезарядишь свой болт, наши ребята впереди уже будут как подушки для иголок! К тому же, разбойники да чудища всякие полных лат не носят! И вообще, хороший лучник может стрелять в то, что ты даже не увидишь своей игрушкой с пружиной.%SPEECH_OFF% Заметив, что вы внимательно прислушиваетесь к их перепалке, оба спорщика умолкают и выжидательно смотрят на вас, прося высказать своё мнение как командира отряда.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Я ценю скорость и дальность лука.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Я предпочитаю мощь и точность арбалета.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Вообще-то, я думаю, что праща - лучший вариант для боя на дистанции.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Arbalester.getImagePath());
				this.Characters.push(_event.m.Hunter.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img][M] Вы заявляете спорщикам, что в настоящем бою превыше всего цените гибкость и скорострельность лука. Услышав это, %hunter% расплывается в довольной ухмылке. %SPEECH_ON%Приятно видеть, что наш капитан, по крайней мере, не дурак.%SPEECH_OFF%Оскорблённый в лучших чувствах %arbalester% лишь злобно отворачивается и начинает яростно бубнить себе под нос. Разобрать поток его бранных слов практически невозможно, однако до вашего слуха отчётливо долетает, как он при каждом удобном случае цедит сквозь зубы: \'тупой ублюдок\'...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Всем не угодишь.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Arbalester.getImagePath());
				this.Characters.push(_event.m.Hunter.getImagePath());
				_event.m.Arbalester.worsenMood(1.5, "Вы не поддержали его в споре");

				if (_event.m.Arbalester.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Arbalester.getMoodState()],
						text = _event.m.Arbalester.getName() + this.Const.MoodStateEvent[_event.m.Arbalester.getMoodState()]
					});
				}

				_event.m.Hunter.improveMood(1.0, "Вы поддержали его в споре");

				if (_event.m.Hunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Hunter.getMoodState()],
						text = _event.m.Hunter.getName() + this.Const.MoodStateEvent[_event.m.Hunter.getMoodState()]
					});
				}

				_event.m.Arbalester.getBaseProperties().Bravery += 2;
				_event.m.Arbalester.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Arbalester.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] к решимости"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img][M] Вы заявляете спорщикам, что никакой лук и близко не стоял рядом с сокрушительной мощью и точностью хорошего арбалета. Услышав это, %arbalester% довольно хохочет: %SPEECH_ON%Рад видеть, что наш капитан, по крайней мере, дружит со здравым смыслом!%SPEECH_OFF%Поверженный в споре %hunter% лишь угрюмо качает головой и погружается в хмурое молчание. На этом перепалка утихает.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Всем не угодишь.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Arbalester.getImagePath());
				this.Characters.push(_event.m.Hunter.getImagePath());
				_event.m.Hunter.worsenMood(1.5, "Вы не поддержали его в споре");

				if (_event.m.Hunter.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Hunter.getMoodState()],
						text = _event.m.Hunter.getName() + this.Const.MoodStateEvent[_event.m.Hunter.getMoodState()]
					});
				}

				_event.m.Arbalester.improveMood(1.0, "Вы поддержали его в споре");

				if (_event.m.Arbalester.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Arbalester.getMoodState()],
						text = _event.m.Arbalester.getName() + this.Const.MoodStateEvent[_event.m.Arbalester.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img][M] Вы усмехаетесь и заявляете обоим спорщикам, что ультимативное оружие дальнего боя - это обычная пастушья праща. Наёмники застывают и смотрят на вас так, словно у вас на плечах только что выросла вторая голова. Озадаченный %hunter% медленно произносит:%SPEECH_ON%Простите, капитан... За долгие годы в лесу я привык доверять своему слуху, но сейчас я готов поклясться, что вы назвали лучшим оружием кусок шкуры с камнем...%SPEECH_OFF%Стоящий рядом %arbalester% внезапно громко смеется. %SPEECH_ON%Я понимаю, капитан, и я согласен. Луки хороши для отстрела уязвимых и важных ублюдков, это я признаю.%SPEECH_OFF% %hunter% в изумлении смотрит на арбалетчика, и его лицо тоже расплывается в улыбке. %SPEECH_ON%Да, и я согласен, что мои самые нелюбимые враги - уроды с деревянными стреломётами.%SPEECH_OFF% Они хлопают друг друга по спинам и увлечённо переводят тему разговора на достоинства местной медовухи и трактирных девок.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Похоже, моя работа здесь сделана.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Arbalester.getImagePath());
				this.Characters.push(_event.m.Hunter.getImagePath());
				_event.m.Arbalester.improveMood(1.0, "Сдружился с братом-стрелком");

				if (_event.m.Arbalester.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Arbalester.getMoodState()],
						text = _event.m.Arbalester.getName() + this.Const.MoodStateEvent[_event.m.Arbalester.getMoodState()]
					});
				}

				_event.m.Hunter.improveMood(1.0, "Сдружился с братом-стрелком");

				if (_event.m.Hunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Hunter.getMoodState()],
						text = _event.m.Hunter.getName() + this.Const.MoodStateEvent[_event.m.Hunter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_arbalester = [];
		local candidates_hunter = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_arbalester")
			{
				candidates_arbalester.push(b);
			}

			if (b.getBackground().getID() == "background.hunter")
			{
				candidates_hunter.push(b);
			}
		}

		if (candidates_arbalester.len() == 0 || candidates_hunter.len() == 0)
		{
			return;
		}

		this.m.Hunter = candidates_hunter[this.Math.rand(0, candidates_hunter.len() - 1)];
		this.m.Arbalester = candidates_arbalester[this.Math.rand(0, candidates_arbalester.len() - 1)];
		// looks too low, will never fire unless it gets to 500, i.e. 10 of them
		this.m.Score = candidates_hunter.len() * 50 + candidates_arbalester.len() * 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"arbalester",
			this.m.Arbalester.getName()
		]);
		_vars.push([
			"hunter",
			this.m.Hunter.getName()
		]);
	}

	function onClear()
	{
		this.m.Arbalester = null;
		this.m.Hunter = null;
	}

});

