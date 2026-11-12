this.barkeep_cures_drunkard_event <- this.inherit("scripts/events/event", {
	m = {
		Barkeep = null,
		Drunkard = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_barkeep_cures_drunkard";
		this.m.Title = "По пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_61.png[/img][M] Пока отряд останавливается на короткий привал, до вашего слуха доносится громкая брань: это %barkeep% яростно отчитывает соратника, а несчастный %drunkard% лишь молча сносит попрёки за очередную попойку.%SPEECH_ON%Ради всего святого, очнись, мы же в походе! Ты ведёшь себя так, будто это последний день твоей никчёмной жизни и ты больше никогда не увидишь проклятую таверну!%SPEECH_OFF%Обруганный соратник лишь сильнее вжимает голову в плечи. %drunkard% судорожно сжимает в руке полупустую бутылку и глухо бормочет.%SPEECH_ON%Те ужасы, которые мы пережили... братья, которых мы потеряли... их мёртвые лица преследуют меня каждую ночь. Выпивка - это единственное, что отгоняет их призраков.%SPEECH_OFF%Бывший трактирщик %barkeep% срывается на крик:%SPEECH_ON%А кто из нас, живых, станет следующим из-за твоей слабости?! Капитан? Я? Если я поймаю вражеский топор только потому, что твоя пьяная задница не способна твёрдо держать щит и махать мечом, клянусь старыми богами - я лично вернусь с того света и даже выпивка не спасёт тебя от моих кошмаров!%SPEECH_OFF%Похоже, эти суровые слова наконец достигают цели. Пока отряд готовится продолжить марш, вы замечаете, как устыдившийся %drunkard% молча отдаёт выпивку, а хмурый %barkeep% забирает бутылку себе.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Давно пора было отобрать бутылку у этого пьяницы.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Barkeep.getImagePath());
				this.Characters.push(_event.m.Drunkard.getImagePath());
				_event.m.Drunkard.getSkills().removeByID("trait.drunkard");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_29.png",
						text = _event.m.Drunkard.getName() + " больше не пьяница"
					}
				];
				_event.m.Barkeep.improveMood(0.5, "Отобрал бутылку у пьяницы.");

				if (_event.m.Barkeep.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Barkeep.getMoodState()],
						text = _event.m.Barkeep.getName() + this.Const.MoodStateEvent[_event.m.Barkeep.getMoodState()]
					});
				}

				_event.m.Drunkard.worsenMood(1.5, "Был унижен перед всем отрядом.");

				if (_event.m.Drunkard.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Drunkard.getMoodState()],
						text = _event.m.Drunkard.getName() + this.Const.MoodStateEvent[_event.m.Drunkard.getMoodState()]
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

		local candidates_barkeep = [];
		local candidates_drunkard = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.drunkard"))
			{
				candidates_drunkard.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_barkeep" && b.getLevel() >= 2)
			{
				candidates_barkeep.push(b);
			}
		}

		if (candidates_drunkard.len() == 0 || candidates_barkeep.len() == 0)
		{
			return;
		}

		this.m.Barkeep = candidates_barkeep[this.Math.rand(0, candidates_barkeep.len() - 1)];
		this.m.Drunkard = candidates_drunkard[this.Math.rand(0, candidates_drunkard.len() - 1)];
		this.m.Score = 15 * candidates_barkeep.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"barkeep",
			this.m.Barkeep.getName()
		]);
		_vars.push([
			"drunkard",
			this.m.Drunkard.getName()
		]);
	}

	function onClear()
	{
		this.m.Barkeep = null;
		this.m.Drunkard = null;
	}

});

