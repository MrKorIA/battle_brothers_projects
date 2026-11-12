this.herbalist_cures_sickness_event <- this.inherit("scripts/events/event", {
	m = {
		Herbalist = null,
		SickBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_herbalist_cures_sickness";
		this.m.Title = "В пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_18.png[/img][M] Отряд снова останавливается: %sickbro% страдает от жестокого приступа тошноты и то и дело останавливается на обочине тракта, выворачивая желудок наизнанку. Видя эти мучения, %herbalist% запускает руку в свой походный мешок и извлекает баночку с пахучей фиолетовой пастой. Травник решительно направляется к страдальцу как раз в тот момент, когда того скручивает очередной рвотный позыв.%SPEECH_ON%Проглоти-ка вот этого снадобья. На вкус оно как полное дерьмо, но желудок должно унять мгновенно.%SPEECH_OFF%Несчастный %sickbro% нехотя макает пальцы в банку, зачерпывает немного вязкой массы и через силу отправляет её себе в рот. Его осунувшееся, бледное лицо уродливо искажается от жуткого отвращения, но он всё же находит в себе силы проглотить это вещество. Завидев это, %herbalist% довольно похлопывает товарища по спине.%SPEECH_ON%Вот и молодец. Скоро снова будешь твёрдо стоять на ногах.%SPEECH_OFF%Оба наёмника возвращаются в строй. И действительно, уже спустя пару часов %sickbro% заметно приободряется, а от его недавней изнуряющей хвори не остаётся и следа.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Нам повезло, что с нами травник.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Herbalist.getImagePath());
				this.Characters.push(_event.m.SickBro.getImagePath());
				_event.m.SickBro.getSkills().removeByID("injury.sickness");
				this.List = [
					{
						id = 10,
						icon = "ui/injury/injury_icon_25.png",
						text = _event.m.SickBro.getName() + " больше не болен"
					}
				];
				_event.m.Herbalist.improveMood(0.5, "Вылечил брата от болезни");

				if (_event.m.Herbalist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Herbalist.getMoodState()],
						text = _event.m.Herbalist.getName() + this.Const.MoodStateEvent[_event.m.Herbalist.getMoodState()]
					});
				}

				_event.m.SickBro.improveMood(1.0, "Вылечился от болезни");

				if (_event.m.SickBro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.SickBro.getMoodState()],
						text = _event.m.SickBro.getName() + this.Const.MoodStateEvent[_event.m.SickBro.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_herbalist = [];
		local candidates_sickbro = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("injury.sickness"))
			{
				candidates_sickbro.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_herbalist" && b.getLevel() >= 4)
			{
				candidates_herbalist.push(b);
			}
		}

		if (candidates_herbalist.len() == 0 || candidates_sickbro.len() == 0)
		{
			return;
		}

		this.m.Herbalist = candidates_herbalist[this.Math.rand(0, candidates_herbalist.len() - 1)];
		this.m.SickBro = candidates_sickbro[this.Math.rand(0, candidates_sickbro.len() - 1)];
		this.m.Score = 250 * candidates_herbalist.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"herbalist",
			this.m.Herbalist.getName()
		]);
		_vars.push([
			"sickbro",
			this.m.SickBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Herbalist = null;
		this.m.SickBro = null;
	}

});

