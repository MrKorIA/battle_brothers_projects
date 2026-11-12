this.torturer_removes_fainthearted_event <- this.inherit("scripts/events/event", {
	m = {
		Torturer = null,
		FaintheartedBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_torturer_removes_fainthearted";
		this.m.Title = "В свободную минуту...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img][M] Во время затяжного перехода вы случайно ровняетесь с хвостом колонны и понимаете, что в шаге от вас увлечённо беседуют %torturer% и %faintheartedbro%. Вы мысленно вскидываете бровь от удивления: мучитель всегда без умолку трепался о своём жутком ремесле, а %faintheartedbro% отличался поразительным малодушием с самого первого дня в вашем отряде. До сих пор этот робкий балбес при любом удобном случае старался держаться как можно дальше от заплечных дел мастера.\n\nВы уже мысленно представляете, как %faintheartedbro% будет съёживаться от ужаса под гнётом леденящих душу рассказов дознавателя. Однако, приглядевшись, вы с изумлением замечаете, что этот тихоня слушает своего мрачного товарища весьма бодро и даже с заметным интересом.",
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
				this.Characters.push(_event.m.FaintheartedBro.getImagePath());
				this.Characters.push(_event.m.Torturer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img][M]%SPEECH_ON%Понимаешь, %faintheartedbro%, на своём веку я ломал самых стойких мужей. Рыцарей, которые и глазом не моргнут, убивая юнцов и беззащитных девушек по приказу своих лордов; шпионов, ослеплённых фанатичной преданностью благородным домам; наёмников, повидавших на трактах вообще всё. Но правда в том, что большинство людей - жалкие создания. Стоило просто волоком притащить их к моему столу, как они уже начинали истошно выть и умолять о пощаде.%SPEECH_OFF%Мучитель разочарованно качает головой, после чего подмигивает шагающему рядом товарищу.%SPEECH_ON%Никакого удовольствия от работы, одно разочарование. Но я к чему клоню, %faintheartedbro%... Просто стоять в нашем строю на поле боя и по-честному отрабатывать контракты, глядя в упор на всё то жуткое дерьмо, с которым мы сталкиваемся ради крон - для этого нужно куда больше мужества, чем было у большинства тех ублюдков, которых я потрошил в подвалах. Если захочешь, можем как-нибудь проверить это на практике.%SPEECH_OFF%При этих словах %torturer% зловеще ухмыляется. Перепуганный %faintheartedbro% сперва искажается в лице от ужаса, но, вовремя осознав мрачную шутку палача, внезапно разражается громким, заливистым хохотом.\n\nКогда вы возвращаетесь к голове колонны, до вас доходит: суровые слова дознавателя попали точно в цель. %faintheartedbro% выглядит совсем иначе - парень марширует с новой, неведомой ему прежде решимостью, а его спина заметно выпрямилась. Остаётся лишь надеяться, что этот внезапный прилив боевого духа не угаснет в грядущих жестоких сражениях...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Похоже, у этого трусишки теперь есть мужество.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Torturer.getImagePath());
				this.Characters.push(_event.m.FaintheartedBro.getImagePath());
				_event.m.FaintheartedBro.getSkills().removeByID("trait.fainthearted");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_41.png",
						text = _event.m.FaintheartedBro.getName() + " больше не малодушный"
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

				_event.m.FaintheartedBro.improveMood(0.5, "Преодолел свою боязнь боя");

				if (_event.m.FaintheartedBro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.FaintheartedBro.getMoodState()],
						text = _event.m.FaintheartedBro.getName() + this.Const.MoodStateEvent[_event.m.FaintheartedBro.getMoodState()]
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
		local candidates_faintheartedbro = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.fainthearted"))
			{
				candidates_faintheartedbro.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_torturer" && b.getLevel() >= 3)
			{
				candidates_torturer.push(b);
			}
		}

		if (candidates_faintheartedbro.len() == 0 || candidates_torturer.len() == 0)
		{
			return;
		}

		this.m.Torturer = candidates_torturer[this.Math.rand(0, candidates_torturer.len() - 1)];
		this.m.FaintheartedBro = candidates_faintheartedbro[this.Math.rand(0, candidates_faintheartedbro.len() - 1)];
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
			"faintheartedbro",
			this.m.FaintheartedBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Torturer = null;
		this.m.FaintheartedBro = null;
	}

});

