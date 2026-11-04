this.torturer_removes_craven_event <- this.inherit("scripts/events/event", {
	m = {
		Torturer = null,
		CravenBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_torturer_removes_craven";
		this.m.Title = "В свободную минуту...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img][M] Во время затяжного перехода вы случайно ровняетесь с хвостом колонны и понимаете, что в шаге от вас увлечённо беседуют %torturer% и %cravenbro%. Вы мысленно вскидываете бровь от удивления: мучитель всегда без умолку трепался о своём жутком ремесле, а %cravenbro% испуганно шарахался от собственной тени столько времени, сколько вы себя помните. До сих пор этот трусливый балбес при любом удобном случае старался держаться как можно дальше от заплечных дел мастера.\n\nВы уже мысленно представляете, как %cravenbro% будет съёживаться от ужаса под гнётом леденящих душу рассказов дознавателя. Однако, приглядевшись, вы с изумлением замечаете, что трус слушает своего мрачного товарища весьма бодро и даже с заметным интересом.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Давайте послушаем их разговор...",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CravenBro.getImagePath());
				this.Characters.push(_event.m.Torturer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img][M]%SPEECH_ON%Понимаешь, %cravenbro%, на своём веку я ломал самых стойких мужей. Рыцарей, которые и глазом не моргнут, убивая юнцов и беззащитных девушек по приказу своих лордов; шпионов, ослеплённых фанатичной преданностью благородным домам; наёмников, повидавших на трактах вообще всё. Но правда в том, что большинство людей - жалкие создания. Стоило просто волоком притащить их к моему столу, как они уже начинали истошно выть и умолять о пощаде.%SPEECH_OFF%Мучитель разочарованно качает головой, после чего подмигивает шагающему рядом товарищу.%SPEECH_ON%Никакого удовольствия от работы, одно разочарование. Но я к чему клоню, %cravenbro%... Просто стоять в нашем строю на поле боя и по-честному отрабатывать контракты, глядя в упор на всё то жуткое дерьмо, с которым мы сталкиваемся ради крон - для этого нужно куда больше мужества, чем было у большинства тех ублюдков, которых я потрошил в подвалах. Если захочешь, можем как-нибудь проверить это на практике.%SPEECH_OFF%При этих словах %torturer% зловеще ухмыляется. Перепуганный %cravenbro% сперва искажается в лице от ужаса, но, вовремя осознав мрачную шутку палача, внезапно разражается громким, заливистым хохотом.\n\nКогда вы возвращаетесь к голове колонны, до вас доходит: суровые слова дознавателя попали точно в цель. %cravenbro% выглядит совсем иначе - в его глазах теперь горит твёрдая решимость вместо прежней жалкой робости. Движения наёмника полны уверенности, спина выпрямлена, а шаг стал шире и твёрже. Вам это кажется невероятным, но внутри зреет искреннее любопытство: как бывший трус проявит себя в следующей жестокой сече?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Подумать только, этому трусливому ублюдку понадобилась поддержка от чёртова мучителя.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Torturer.getImagePath());
				this.Characters.push(_event.m.CravenBro.getImagePath());
				_event.m.CravenBro.getSkills().removeByID("trait.craven");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_40.png",
						text = _event.m.CravenBro.getName() + " больше не трус"
					}
				];
				_event.m.Torturer.improveMood(0.5, "Использовал свой опыт, чтобы подбодрить товарища");

				if (_event.m.Torturer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Torturer.getMoodState()],
						text = _event.m.Torturer.getName() + this.Const.MoodStateEvent[_event.m.Torturer.getMoodState()]
					});
				}

				_event.m.CravenBro.improveMood(0.5, "Преодолел свою боязнь боя");

				if (_event.m.CravenBro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.CravenBro.getMoodState()],
						text = _event.m.CravenBro.getName() + this.Const.MoodStateEvent[_event.m.CravenBro.getMoodState()]
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

		local candidates_torturer = [];
		local candidates_cravenbro = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.craven"))
			{
				candidates_cravenbro.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_torturer" && b.getLevel() >= 5)
			{
				candidates_torturer.push(b);
			}
		}

		if (candidates_cravenbro.len() == 0 || candidates_torturer.len() == 0)
		{
			return;
		}

		this.m.Torturer = candidates_torturer[this.Math.rand(0, candidates_torturer.len() - 1)];
		this.m.CravenBro = candidates_cravenbro[this.Math.rand(0, candidates_cravenbro.len() - 1)];
		this.m.Score = 15 * candidates_torturer.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"torturer",
			this.m.Torturer.getName()
		]);
		_vars.push([
			"cravenbro",
			this.m.CravenBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Torturer = null;
		this.m.CravenBro = null;
	}

});

