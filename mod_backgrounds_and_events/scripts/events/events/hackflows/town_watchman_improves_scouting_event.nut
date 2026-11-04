this.town_watchman_improves_scouting_event <- this.inherit("scripts/events/event", {
	m = {
		TownWatchman = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_town_watchman_improves_scouting";
		this.m.Title = "По пути...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_90.png[/img][M] Прямо во время перехода %townwatchman% аккуратно касается вашего плеча, привлекая к себе внимание. Бывший городской стражник устремляет взгляд на дорогу и негромко заводит разговор.%SPEECH_ON%Капитан, когда вы нанимали меня, вы прекрасно знали, кем я был в прежней жизни. Но вы никогда не расспрашивали, почему я вдруг бросил службу и решил податься в наёмники.%SPEECH_OFF%Чувствуя, что ветеран собирается излить душу, вы просто молча киваете ему в ответ. Тот тяжело вздыхает.%SPEECH_ON%Правда в том, что служба в страже довольно легка. Нам редко приходилось стоять на передовой. Более того, если ты служишь в большом городе, в большинстве случаев от тебя требуется лишь вовремя поднять тревогу. И всё же местные относились к нам как к заправским защитникам, как к храбрецам, которым доверили покой мирных граждан.\n\n...И это подводит меня к самому главному. Такой тупой ублюдок, как я, знатно перебрал с элем после очередного местного праздника. Я обязан был позволить сменщику заступить на ночное дежурство, но из упрямства не сделал этого. К тому моменту, когда я продрал глаза, заметил опасность и ударил в набат, чёртовы бандиты уже хозяйничали на улицах, безжалостно грабя и вырезая всех подряд.%SPEECH_OFF%Вы поворачиваетесь, и в этот момент %townwatchman% впервые с тех пор, как вы его наняли, едва сдерживает набежавшие слёзы.%SPEECH_ON%Все мои товарищи по ополчению, мои верные друзья, которые раз за разом бросались на стены по первому моему призыву... Они сражались как львы, но многие даже не успели натянуть кольчуги.%SPEECH_OFF%Он надолго умолкает. Некоторое время вы шагаете рядом в полном безмолвии, слушая лишь хруст гравия, пока стражник снова не прерывает тишину.%SPEECH_ON%Они все погибли из-за моей халатности, капитан. Само собой, после такого я больше не мог показываться дома. Но я поклялся старыми богами, что ни один отряд, к которому я примкну, никогда больше не погибнет из-за внезапной засады... По крайней мере, пока я дышу!\n\nМне было чертовски трудно на ходу оттачивать свою наблюдательность в полевых условиях. Понимаете, во время караулов на городских стенах обстановка из года в год оставалась неизменной. Но теперь, когда я окончательно привык к тяготам наёмничьей жизни, вы сами увидите: будь то ясный день или глухая ночь, ни одному скользкому ублюдку не удастся подобраться к нашему лагерю незамеченным, пока я стою на часах!%SPEECH_OFF%Договорив, %townwatchman% с вызовом выпрямляет спину. Становится очевидно, что этот парень отчаянно искал искупления за грехи прошлого с самого первого дня в отряде. Остаётся лишь дружески хлопнуть ветерана по плечу, подбадривая перед грядущими битвами, и вскоре вы оба возвращаетесь в общий строй.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Желаю тебе удачи и спасибо.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.TownWatchman.getImagePath());
				_event.m.TownWatchman.improveMood(0.5, "Улучшил возможности разведки отряда");
				_event.m.TownWatchman.improveMood(1.0, "Провел значимый разговор с капитаном");

				if (_event.m.TownWatchman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.TownWatchman.getMoodState()],
						text = _event.m.TownWatchman.getName() + this.Const.MoodStateEvent[_event.m.TownWatchman.getMoodState()]
					});
				}

				local gt = this.getroottable();
				gt.Const.World.TerrainTypeVisionRadiusMult <- [
					1.1,
					1.1,
					1.1,
					1.1,
					2.2,
					1.1,
					1.1,
					1.1,
					1.1,
					6.5999999,
					1.1,
					1.1,
					1.1,
					1.1,
					1.1,
					1.1,
					1.1
				];
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Теперь ваш отряд видит дальше при передвижении по карте мира"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_town_watchman = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_town_watchman" && b.getLevel() >= 10)
			{
				candidates_town_watchman.push(b);
			}
		}

		if (candidates_town_watchman.len() == 0)
		{
			return;
		}

		this.m.TownWatchman = candidates_town_watchman[this.Math.rand(0, candidates_town_watchman.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townwatchman",
			this.m.TownWatchman.getName()
		]);
	}

	function onClear()
	{
		this.m.TownWatchman = null;
	}

});

