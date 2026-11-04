this.herbalist_cures_ailing_event <- this.inherit("scripts/events/event", {
	m = {
		Herbalist = null,
		AilingBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_herbalist_cures_ailing";
		this.m.Title = "В пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_128.png[/img][M] Прямо во время перехода до вашего слуха доносится, как в хвосте колонны жалобно давится рвотой %ailingBro%. Причиной тому могло стать всё что угодно: несвежая солонина на привале, болотная лихорадка, въевшийся запах крови после прошлой резни или что угодно ещё.\n\nКогда отряд вынужденно замедляет ход в который уже раз за сегодня, %herbalist% решительно запускает руку в свой походный мешок, извлекает склянку с мутной зелёной жижей и протягивает её страдальцу. Сам он при этом сухо приказывает.%SPEECH_ON%Пей.%SPEECH_OFF%Несчастный %ailingBro% лишь кривится от отвращения и хрипло возмущается.%SPEECH_ON%Ты уморить меня вздумал, псих ненормальный?! Да ты погляди на меня, я и без твоего пойла уже зелёный как поганка!%SPEECH_OFF%Вы строго напоминаете больному, что из-за его недуга весь отряд ползёт как старая черепаха. Смирившись, %ailingBro% нехотя принимает пузырёк, судорожно сдерживает очередной рвотный позыв и залпом выпивает содержимое.\n\nВ ту же секунду бедолага начинает яростно кашлять и ругаться на чём свет стоит из-за убойного горького вкуса. Самые грязные оскорбления летят в адрес травника и всей его родни, однако %herbalist% выслушивает этот поток брани с абсолютным, стоическим спокойствием.%SPEECH_ON%Твои крики не произведут на меня ровным счётом никакого впечатления - главное, чтобы ты перестал изливать свои внутренности прямо на мои сапоги.%SPEECH_OFF%Услышав это, умолкнувший %ailingBro% на миг застывает, прислушиваясь к ощущениям в желудке. Осознав, что дурнота внезапно отступила, он смущённо опускает голову, бормочет неожиданно искренние извинения и возвращается в строй.",
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
				this.Characters.push(_event.m.AilingBro.getImagePath());
				_event.m.AilingBro.getSkills().removeByID("trait.ailing");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_59.png",
					text = _event.m.AilingBro.getName() + " больше не болен"
				});
				_event.m.Herbalist.improveMood(0.5, "Излечил болезнь боевого брата");

				if (_event.m.Herbalist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Herbalist.getMoodState()],
						text = _event.m.Herbalist.getName() + this.Const.MoodStateEvent[_event.m.Herbalist.getMoodState()]
					});
				}

				_event.m.AilingBro.improveMood(1.5, "Его здоровье было восстановлено травником");

				if (_event.m.AilingBro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.AilingBro.getMoodState()],
						text = _event.m.AilingBro.getName() + this.Const.MoodStateEvent[_event.m.AilingBro.getMoodState()]
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

		local candidates_herbalist = [];
		local candidates_ailingBro = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.ailing"))
			{
				candidates_ailingBro.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_herbalist" && b.getLevel() >= 4)
			{
				candidates_herbalist.push(b);
			}
		}

		if (candidates_ailingBro.len() == 0 || candidates_herbalist.len() == 0)
		{
			return;
		}

		this.m.Herbalist = candidates_herbalist[this.Math.rand(0, candidates_herbalist.len() - 1)];
		this.m.AilingBro = candidates_ailingBro[this.Math.rand(0, candidates_ailingBro.len() - 1)];
		this.m.Score = 15 * candidates_herbalist.len();
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
			"ailingBro",
			this.m.AilingBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Herbalist = null;
		this.m.AilingBro = null;
	}

});

