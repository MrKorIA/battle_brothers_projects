this.herbalist_cures_asthma_event <- this.inherit("scripts/events/event", {
	m = {
		Herbalist = null,
		AsthmaticBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_herbalist_cures_asthma";
		this.m.Title = "В пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_128.png[/img][M] Прямо во время перехода из хвоста колонны доносится натужный, свистящий хрип, который издаёт %asthmaticBro%. Из-за своего давнего недуга лёгких ему всегда было тяжело поспевать за остальными, но сегодня отряд вынужден плестись особенно медленно, то и дело останавливаясь по его вине.\n\nЗаметив задержку, %herbalist% оперативно достаёт из походной сумки целебную смесь сушёных трав с нюхательной солью и бережно протягивает её задыхающемуся соратнику. Он жестом велит ему сделать глубокий вдох.\n\nПосле первого вдоха %asthmaticBro% морщит нос, но средство возымело немедленный эффект. Избавившись от удушья, он расплывается в довольной ухмылке и от всего сердца благодарит своего спасителя. Похоже, это чудодейственное снадобье навсегда избавило бедолагу от удушающей хватки астмы!",
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
				this.Characters.push(_event.m.AsthmaticBro.getImagePath());
				_event.m.AsthmaticBro.getSkills().removeByID("trait.asthmatic");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_22.png",
						text = _event.m.AsthmaticBro.getName() + " больше не страдает астмой"
					}
				];
				_event.m.Herbalist.improveMood(0.5, "Вылечил брата от астмы");

				if (_event.m.Herbalist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Herbalist.getMoodState()],
						text = _event.m.Herbalist.getName() + this.Const.MoodStateEvent[_event.m.Herbalist.getMoodState()]
					});
				}

				_event.m.AsthmaticBro.improveMood(1.5, "Вылечился от астмы");

				if (_event.m.AsthmaticBro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.AsthmaticBro.getMoodState()],
						text = _event.m.AsthmaticBro.getName() + this.Const.MoodStateEvent[_event.m.AsthmaticBro.getMoodState()]
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
		local candidates_asthmaticBro = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.asthmatic"))
			{
				candidates_asthmaticBro.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_herbalist" && b.getLevel() >= 4)
			{
				candidates_herbalist.push(b);
			}
		}

		if (candidates_asthmaticBro.len() == 0 || candidates_herbalist.len() == 0)
		{
			return;
		}

		this.m.Herbalist = candidates_herbalist[this.Math.rand(0, candidates_herbalist.len() - 1)];
		this.m.AsthmaticBro = candidates_asthmaticBro[this.Math.rand(0, candidates_asthmaticBro.len() - 1)];
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
			"asthmaticBro",
			this.m.AsthmaticBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Herbalist = null;
		this.m.AsthmaticBro = null;
	}

});

