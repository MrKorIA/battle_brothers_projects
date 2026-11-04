this.skirmisher_trains_stealth_event <- this.inherit("scripts/events/event", {
	m = {
		Skirmisher = null,
		OtherBro1 = null,
		OtherBro2 = null,
		OtherBro3 = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_skirmisher_trains_stealth";
		this.m.Title = "В Пути...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_134.png[/img][M] Прямо во время перехода вы замечаете, что %skirmisher% увлечённо читает лекцию троим другим членам вашего отряда. Застрельщик, судя по всему, решил устроить для парней импровизированный урок по партизанской тактике.%SPEECH_ON%Слушайте сюда, балбесы! Главная суть в том, чтобы заставить вражеского ублюдка целиться именно в вас. Вы обязаны прикидываться дурачками, чтобы лучник поверил, будто вы напрочь про него забыли - но в то же мгновение ваш щит уже должен быть наготове, чтобы принять удар на себя!%SPEECH_OFF%Шагающий рядом %otherBro1% недоверчиво качает головой.%SPEECH_ON%Да как, чёрт тебя дери, нам провернуть этот трюк и не словить при этом какой-нибудь острый наконечник прямо в брюхо?%SPEECH_OFF%На это %skirmisher% лишь уверенно ухмыляется.%SPEECH_ON%Работать щитом нужно быстрее, вот и весь секрет. Понятно, что лучший способ не словить стрелу - это вообще не лезть под обстрел. Но когда в разгаре сечи вокруг летает столько всякого смертоносного дерьма, ни в чём нельзя быть уверенным на все сто процентов.%SPEECH_OFF%Обсуждение боевых приёмов продолжается до самого привала. Похоже, в итоге некоторые из ваших людей действительно усваивают парочку полезных хитростей, которые помогут им уклоняться от вражеских стрел в грядущих битвах.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Отличная работа.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Skirmisher.getImagePath());
				_event.m.Skirmisher.improveMood(0.5, "Научил некоторых братьев уклоняться от стрел.");

				if (_event.m.Skirmisher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Skirmisher.getMoodState()],
						text = _event.m.Skirmisher.getName() + this.Const.MoodStateEvent[_event.m.Skirmisher.getMoodState()]
					});
				}

				_event.m.OtherBro1.getBaseProperties().RangedDefense += 6;
				_event.m.OtherBro2.getBaseProperties().RangedDefense += 6;
				_event.m.OtherBro3.getBaseProperties().RangedDefense += 6;
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.OtherBro1.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+6[/color] к защите в дальнем бою"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.OtherBro2.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+6[/color] к защите в дальнем бою"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.OtherBro3.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+6[/color] к защите в дальнем бою"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 5)
		{
			return;
		}

		local candidates_skirmisher = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_skirmisher")
			{
				candidates_skirmisher.push(b);
			}
			else if (this.m.OtherBro1 == null)
			{
				this.m.OtherBro1 = b;
			}
			else if (this.m.OtherBro2 == null)
			{
				this.m.OtherBro2 = b;
			}
			else if (this.m.OtherBro3 == null)
			{
				this.m.OtherBro3 = b;
			}
		}

		if (candidates_skirmisher.len() == 0 || this.m.OtherBro1 == null || this.m.OtherBro2 == null || this.m.OtherBro3 == null)
		{
			return;
		}

		this.m.Skirmisher = candidates_skirmisher[this.Math.rand(0, candidates_skirmisher.len() - 1)];
		this.m.Score = candidates_skirmisher.len() * 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherBro1",
			this.m.OtherBro1.getName()
		]);
		_vars.push([
			"otherBro2",
			this.m.OtherBro2.getName()
		]);
		_vars.push([
			"otherBro3",
			this.m.OtherBro3.getName()
		]);
		_vars.push([
			"skirmisher",
			this.m.Skirmisher.getName()
		]);
	}

	function onClear()
	{
		this.m.Skirmisher = null;
		this.m.OtherBro1 = null;
		this.m.OtherBro2 = null;
		this.m.OtherBro3 = null;
	}

});

