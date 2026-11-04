this.hangman_hangs_wiederganger_event <- this.inherit("scripts/events/event", {
	m = {
		Hangman = null,
		OtherBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_hangman_hangs_wiederganger";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img][M] Отряд уже готовится разбить лагерь, как вдруг до вашего слуха доносится нестройный хор улюлюканий и удивлённых криков. Вы поспешно направляетесь на шум и обнаруживаете своих людей, столпившихся вокруг раскидистого дерева. Подняв глаза к кроне, вы застываете: на толстом суку качается человеческий торс, подвешенный за шею. Его обрубленные руки безвольно болтаются на ветру, а вот нижней половины трупа нигде вокруг не видно...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Какого чёрта здесь происходит?",
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
			Text = "[img]gfx/ui/events/event_02.png[/img][M] Перекрывая нестройный гул голосов, вы яростно рычите, требуя немедленных объяснений. В этот момент из-за раскидистого ствола вальяжно выходит %hangman%. Палач довольно отряхивает ладони, так и сияя от гордости, после чего охотно поясняет.%SPEECH_ON%Да мы тут с парнями приметили этот жалкий огрызок, пока он полз по грязи. Наступить в темноте на такого ублюдка было бы паршиво, так что мы решили его подвесить и немного развлечься!%SPEECH_OFF%Словно в ответ на его слова, обрубок плоти внезапно издаёт глухой хрип. Труп судорожно вскидывает костлявые руки, силясь схватить воздух, и испускает утробное рычание, сильно заглушённое стянувшей горло верёвкой. Завидев это, %hangman% заливается громким хохотом и подмигивает соратнику.%SPEECH_ON%Смотри-ка, %otherbro%, кажись, этот уродец признал в тебе папочку! Чего стоишь, обними сынка!%SPEECH_OFF%Стоящий рядом %otherbro% ухает от смеха и тут же парирует.%SPEECH_ON%Да чёрта с два этот недоносок мой! Ты глянь на него - у него ж твой огромный бычий лоб и такое же дебильное косоглазие!%SPEECH_OFF%Подобный дружеский обмен колкостями и бранью весело продолжается между братьями. Осознав, что никакой реальной опасности для отряда эта привязанная туша не представляет, вы со вздохом разворачиваетесь и возвращаетесь к лагерной рутине.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это точно один из способов снять стресс...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hangman.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Развлёкся, глядя на подвешенного зомби");

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

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_hangman = [];
		local candidates_other = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.executioner")
			{
				candidates_hangman.push(b);
			}
			else
			{
				candidates_other.push(b);
			}
		}

		if (candidates_hangman.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.OtherBro = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Hangman = candidates_hangman[this.Math.rand(0, candidates_hangman.len() - 1)];
		this.m.Score = candidates_hangman.len() * 10;
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
			"otherbro",
			this.m.OtherBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Hangman = null;
		this.m.OtherBro = null;
	}

});

