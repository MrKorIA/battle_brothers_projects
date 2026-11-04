this.hangman_vs_criminal_event <- this.inherit("scripts/events/event", {
	m = {
		Hangman = null,
		Criminal = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_hangman_vs_criminal";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img][M] После долгого, изнурительного перехода ваши люди собираются у костра, коротая время за байками о своём прошлом. Вскоре все умолкают, и %hangman% понимает, что наступила его очередь делиться историей. Палач лишь равнодушно пожимает плечами, подбрасывая ветку в огонь.%SPEECH_ON%Да особо и рассказывать-то нечего, парни. Когда я был совсем зелёным, в наших краях объявился серийный душегуб и насильник. В конце концов мы поймали этого ублюдка и вздёрнули на первом попавшемся суку. Самосуд, все дела. Мне выпала честь его вздёрнуть... Думаю, местным понравилось, как ловко у меня всё вышло, потому что вскоре городские старосты начали нанимать меня на казни уже за звонкую монету. Со временем дело пошло в гору, мы даже сколотили настоящую эшафотную платформу с откидным люком и всё такое!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "...",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hangman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img][M] Сидящие у костра наёмники дружно хохочут и гогочут, от нелепости услышанного рассказа. В этот момент %hangman% указывает пальцем на сидящего напротив соратника, которым оказывается %criminal%, и веско продолжает.%SPEECH_ON%Того первого ублюдка, которого я вздёрнул, я ненавидел всей душой. Но правда в том, что с годами это превратилось в обычную подённую работу ради куска хлеба. Я без лишних мыслей дёргал за рычаг, казня убийц, мелких воришек и пойманных разбойников. На моём веку оборвался земной путь многих могильщиков, браконьеров и дезертиров. Я даже затягивал петлю на шеях тех глупых крестьян, которые слишком много и громко трепались о местных благородных лордах.%SPEECH_OFF%Смех и весёлый гул мгновенно утихают - у костра воцаряется гнетущее безмолвие. Некоторое время %hangman% молча сверлит собеседника стальным, пронзительным взглядом, после чего его суровое лицо внезапно расплывается в широкой улыбке.%SPEECH_ON%Знаешь, укорачивая жизни всей этой швали, я больше никогда не испытывал и доли того азарта, что при первом повешении. Я жил пустой, серой жизнью, парни. Вот почему я здесь. Та ремесленная работёнка была полным дерьмом. Куда приятнее сражаться и исходить кровью бок о бок с такими же отпетыми ублюдками, как вы!%SPEECH_OFF%Услышав это, %criminal% шутливо поднимает палец и указывает в ответ на палача.%SPEECH_ON%И тебе того же, чёртов чудак! Такие, как мы, боятся самой петли, а вовсе не человека, который за ней стоит. Кроны есть кроны, и работа есть работа.%SPEECH_OFF%Напряжение у огня мгновенно спадает, уступая место искреннему, суровому воодушевлению. Интуиция подсказывает вам, что этот честный мужской разговор изрядно укрепил узы боевого братства и поднял боевой дух всего отряда.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Всё хорошо, что хорошо кончается.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hangman.getImagePath());
				this.Characters.push(_event.m.Criminal.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getMoodState() <= this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Услышал разговор по душам между палачом и братом с криминальным прошлым");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_hangman = [];
		local candidates_criminal = [];

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.executioner")
			{
				this.candidates_hangman.push(b);
			}
			else if (b.getBackground().getID() == "background.killer_on_the_run" || b.getBackground().getID() == "background.graverobber" || b.getBackground().getID() == "background.thief" || b.getBackground().getID() == "background.hackflows_myrmidon" || b.getBackground().getID() == "background.deserter" || b.getBackground().getID() == "background.poacher" || b.getBackground().getID() == "background.hackflows_con_artist" || b.getBackground().getID() == "background.hackflows_dissenter" || b.getBackground().getID() == "background.hackflows_pirate" || b.getBackground().getID() == "background.raider")
			{
				candidates_criminal.push(b);
			}
		}

		if (candidates_hangman.len() == 0 || candidates_criminal.len() == 0)
		{
			return;
		}

		this.m.Criminal = candidates_criminal[this.Math.rand(0, candidates_criminal.len() - 1)];
		this.m.Hangman = candidates_hangman[this.Math.rand(0, candidates_hangman.len() - 1)];
		this.m.Score = candidates_hangman.len() * 10 + candidates_criminal.len() * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hangman",
			this.m.Hangman.getName()
		]);
		_vars.push([
			"criminal",
			this.m.Criminal.getName()
		]);
	}

	function onClear()
	{
		this.m.Hangman = null;
		this.m.Criminal = null;
	}

});

